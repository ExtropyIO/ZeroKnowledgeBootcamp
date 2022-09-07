import {
  Field,
  SmartContract,
  state,
  State,
  method,
  PrivateKey,
  PublicKey,
  Poseidon,
} from 'snarkyjs';

export class MessageBoard extends SmartContract {
  // On-chain state definitions
  @state(Field) message = State<Field>();
  @state(Field) messageHistoryHash = State<Field>();
  @state(PublicKey as any) user1 = State<PublicKey>(); //(as any) quick fix as there is a bug in the latest snarkyJS :(
  @state(PublicKey as any) user2 = State<PublicKey>();
  @state(PublicKey as any) user3 = State<PublicKey>();

  @method init(_user1: PublicKey, _user2: PublicKey, _user3: PublicKey) {
    // Define initial values of on-chain state
    this.user1.set(_user1);
    this.user2.set(_user2);
    this.user3.set(_user3);
    this.message.set(Field.zero);
    this.messageHistoryHash.set(Field.zero);
  }

  @method publishMessage(message: Field, signerPrivateKey: PrivateKey) {
    // Compute signerPublicKey from signerPrivateKey argument
    const signerPublicKey = signerPrivateKey.toPublicKey();
    // Get approved public keys
    const user1 = this.user1.get();
    const user2 = this.user2.get();
    const user3 = this.user3.get();
    // Assert that signerPublicKey is one of the approved public keys
    signerPublicKey
      .equals(user1)
      .or(signerPublicKey.equals(user2))
      .or(signerPublicKey.equals(user3))
      .assertEquals(true);
    // Update on-chain message variable
    this.message.set(message);
    // Compute new messageHistoryHash
    const oldHash = this.messageHistoryHash.get();
    const newHash = Poseidon.hash([message, oldHash]);
    // Update on-chain state
    this.messageHistoryHash.set(newHash);
  }
}
