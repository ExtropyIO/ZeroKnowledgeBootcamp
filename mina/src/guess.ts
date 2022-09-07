import {
  Field,
  PublicKey,
  SmartContract,
  state,
  State,
  PrivateKey,
  method,
  UInt64,
  Poseidon,
  Signature,
} from 'snarkyjs';

export class Guess extends SmartContract {
  @state(Field) hashOfGuess = State<Field>();
  @state(PublicKey as any) ownerAddr = State<PublicKey>();
  @state(Field) pot = State<Field>();

  @method init(initialbalance: UInt64, ownerAddr: PublicKey, potValue: Field) {
    this.ownerAddr.set(ownerAddr);
    this.balance.addInPlace(initialbalance);
    this.pot.set(potValue);
  }

  @method startRound(numberToGuess: Field, callerPrivKey: PrivateKey) {
    const ownerAddr = this.ownerAddr.get();
    const callerAddr = callerPrivKey.toPublicKey();
    const potValue = this.pot.get();
    callerAddr.assertEquals(ownerAddr);
    this.balance.addInPlace(new UInt64(potValue));
    this.hashOfGuess.set(Poseidon.hash([numberToGuess.add(potValue)]));
  }
  // //another way to do access control
  @method startRoundWithSig(x: Field, signature: Signature, guess: Field) {
    let ownerAddr = this.ownerAddr.get();
    signature.verify(ownerAddr, [x]).assertEquals(true);
    this.hashOfGuess.set(Poseidon.hash([guess]));
  }

  @method submitGuess(guess: Field) {
    let potValue = this.pot.get();
    let userHash = Poseidon.hash([guess.add(potValue)]);
    let stateHash = this.hashOfGuess.get();
    stateHash.assertEquals(userHash);
  }

  @method guessMultiplied(guess: Field, result: Field) {
    let potValue = this.pot.get();
    const onChainHash = this.hashOfGuess.get();
    onChainHash.assertEquals(Poseidon.hash([guess.add(potValue)]));
    let multiplied = Field(guess).mul(2);
    multiplied.assertEquals(result);
    this.balance.subInPlace(new UInt64(potValue));
  }
}
