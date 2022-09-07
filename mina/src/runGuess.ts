import * as readline from 'readline';
import {
  Field,
  isReady,
  Mina,
  Party,
  PrivateKey,
  UInt64,
  shutdown,
  Permissions,
} from 'snarkyjs';
import { Guess } from './guess.js';

let rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
});
function askQuestion(theQuestion: string): Promise<string> {
  return new Promise((resolve) =>
    rl.question(theQuestion, (answ) => resolve(answ))
  );
}
const doProofs = false;

export async function run() {
  await isReady;
  // initilize local blockchain
  const Local = Mina.LocalBlockchain();
  Mina.setActiveInstance(Local);

  // the mock blockchain gives you access to 10 accounts
  const deployerAcc = Local.testAccounts[0].privateKey;
  const ownerAcc = Local.testAccounts[1].privateKey;
  const playerAcc = Local.testAccounts[2].privateKey;

  const zkAppPrivkey = PrivateKey.random();
  const zkAppAddress = zkAppPrivkey.toPublicKey();

  const zkAppInstance = new Guess(zkAppAddress);
  if (doProofs) {
    try {
      await Guess.compile(zkAppAddress);
    } catch (err) {
      console.log(err);
    }
  }
  let potValue = Field(25000);
  //transaction to deploy the smart contract and init its values
  const tx = await Mina.transaction(deployerAcc, () => {
    const initialBalance = UInt64.fromNumber(100000000);
    Party.fundNewAccount(deployerAcc, { initialBalance: initialBalance });
    // Party.fundNewAccount(deployerAcc);
    zkAppInstance.deploy({
      zkappKey: zkAppPrivkey,
    });
    zkAppInstance.setPermissions({
      ...Permissions.default(),
      editState: Permissions.proofOrSignature(),
      receive: Permissions.proofOrSignature(),
      send: Permissions.proofOrSignature(),
    });
    zkAppInstance.init(initialBalance, ownerAcc.toPublicKey(), potValue);
  });
  await tx.send().wait();

  console.log(
    'zkApp balance after deployment: ',
    Mina.getBalance(zkAppAddress).toString()
  );

  console.log(
    'owner balance before starting round: ',
    Mina.getBalance(ownerAcc.toPublicKey()).toString()
  );
  console.log('Owner starts the round');
  let guess = await askQuestion('what should be the secret number? \n');
  try {
    const tx2 = await Mina.transaction(ownerAcc, () => {
      let userParty = Party.createSigned(ownerAcc);

      zkAppInstance.startRound(Field(guess), ownerAcc);
      userParty.balance.subInPlace(new UInt64(potValue));
      if (!doProofs) {
        zkAppInstance.sign(zkAppPrivkey);
      }
    });
    if (doProofs) await tx2.prove();
    await tx2.send().wait();
  } catch (err) {
    console.log(err);
  }
  console.log(
    'owner balance after starting round: ',
    Mina.getBalance(ownerAcc.toPublicKey()).toString()
  );
  await sleep(1000);
  console.log('Switching to user 2 in 3 sec...');
  await sleep(1000);
  console.log('2 sec ...');
  await sleep(1000);
  console.log('1 sec ...');
  await sleep(1000);
  //   console.clear();

  console.log(
    'Player starting balance  ',
    Mina.getBalance(playerAcc.toPublicKey()).toString()
  );
  console.log(
    'hash of the guess is:',
    zkAppInstance.hashOfGuess.get().toString()
  );
  let usersGuess = await askQuestion('Hey user2, what is your guess? \n');
  try {
    const tx3 = await Mina.transaction(playerAcc, () => {
      zkAppInstance.submitGuess(Field(usersGuess));
      if (!doProofs) {
        zkAppInstance.sign(zkAppPrivkey);
      }
    });
    if (doProofs) await tx3.prove();
    await tx3.send().wait();

    console.log('Correct guess but ...');
  } catch {
    console.log('Wrong guess!!');
    return;
  }

  console.log('Validate that you are not a robot 🤖🤖🤖');
  let multipliedValue = await askQuestion('your guess multiplied by 2 is : \n');

  try {
    const tx4 = await Mina.transaction(playerAcc, () => {
      zkAppInstance.guessMultiplied(Field(usersGuess), Field(multipliedValue));
      let userParty = Party.createUnsigned(playerAcc.toPublicKey());
      userParty.balance.addInPlace(new UInt64(potValue));
      if (!doProofs) {
        zkAppInstance.sign(zkAppPrivkey);
      }
    });
    if (doProofs) await tx4.prove();
    await tx4.send().wait();
    console.log('correct!');
    console.log(
      'Player balance after correct guess ',
      Mina.getBalance(playerAcc.toPublicKey()).toString()
    );
    console.log(
      'owner balance after correct guess of the player: ',
      Mina.getBalance(ownerAcc.toPublicKey()).toString()
    );
    console.log(
      'zkApp balance after payout: ',
      Mina.getBalance(zkAppAddress).toString()
    );
  } catch (e) {
    console.log(e);
    console.log("wrong, you're a robot!");
  }
}

(async function () {
  await run();
  await shutdown();
})();

function sleep(ms: number) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}
