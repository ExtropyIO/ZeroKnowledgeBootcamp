import * as readline from 'readline';
import {
  Field,
  isReady,
  Mina,
  Party,
  PrivateKey,
  shutdown,
  Permissions,
} from 'snarkyjs';
import { MessageBoard } from './messageBoard.js';

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
  const Bob = Local.testAccounts[1].privateKey;
  const SuperBob = Local.testAccounts[2].privateKey;
  const MegaBob = Local.testAccounts[3].privateKey;
  const Jack = Local.testAccounts[4].privateKey;
  let users = [Bob, SuperBob, MegaBob, Jack];

  const zkAppPrivkey = PrivateKey.random();
  const zkAppAddress = zkAppPrivkey.toPublicKey();

  const zkAppInstance = new MessageBoard(zkAppAddress);
  if (doProofs) {
    await MessageBoard.compile(zkAppAddress);
  }
  //transaction to deploy the smart contract and init it's values
  const txn = await Mina.transaction(deployerAcc, () => {
    Party.fundNewAccount(deployerAcc);
    zkAppInstance.deploy({ zkappKey: zkAppPrivkey });
    zkAppInstance.setPermissions({
      ...Permissions.default(),
      editState: Permissions.proofOrSignature(),
    });
    zkAppInstance.init(
      Bob.toPublicKey(),
      SuperBob.toPublicKey(),
      MegaBob.toPublicKey()
    );
  });
  await txn.send().wait();
  console.log(
    'the message on chain is:',
    zkAppInstance.message.get().toString()
  );
  console.log(
    'the hash of the message is:',
    zkAppInstance.messageHistoryHash.get().toString()
  );
  await publishMsg();
  async function publishMsg() {
    let value = await askQuestion(
      'select the user: \n 1) Bob \n 2) SuperBob \n 3) MegaBob \n 4) Jack \n'
    );
    let usersIndex = parseInt(value);
    if (usersIndex < 1 || usersIndex > 4 || isNaN(usersIndex)) {
      console.log('invalid input');
      return;
    }
    usersIndex--;
    let selectedUser = users[usersIndex];
    console.log('Switching to user number', value, 'in 2 sec...');
    await sleep(1000);
    console.log('1 sec ...');
    await sleep(1000);
    console.log('-----USER SWITCHED-----');
    let message = await askQuestion('Enter message(digits only): ');
    try {
      const tx1 = await Mina.transaction(selectedUser, () => {
        zkAppInstance.publishMessage(Field(message), selectedUser);
        if (!doProofs) {
          zkAppInstance.sign(zkAppPrivkey);
        }
      });
      if (doProofs) await tx1.prove();
      await tx1.send().wait();
    } catch (e) {
      console.log(e);
    }
    console.log(
      'the message on chain is:',
      zkAppInstance.message.get().toString()
    );
    console.log(
      'the hash of the message is:',
      zkAppInstance.messageHistoryHash.get().toString()
    );
    await publishMsg();
  }
}

(async function () {
  await run();
  await shutdown();
})();

function sleep(ms: number) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}
