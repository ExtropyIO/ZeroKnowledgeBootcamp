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
  Circuit,
  Bool,
} from 'snarkyjs';

export class Odds extends SmartContract {
  @state(Field) hashedOdd = State<Field>();
  @state(Field) oddRange = State<Field>();
  @state(Field) gameStake = State<Field>();
  @state(PublicKey as any) winner = State<PublicKey>();
  @state(PublicKey as any) player1 = State<PublicKey>();
  @state(PublicKey as any) player2 = State<PublicKey>();
  @state(Bool) isPayoutReady = State<Bool>();

  @method init(
    player1: PrivateKey,
    player2: PublicKey,
    oddRangeValue: Field,
    gameStake: Field
  ) {
    this.player1.set(player1.toPublicKey());
    this.player2.set(player2);
    this.oddRange.set(oddRangeValue);
    this.gameStake.set(gameStake);
    this.isPayoutReady.set(Bool(false));
  }

  @method commit(theOdd: Field, player1PrivKey: PrivateKey) {
    const player1 = this.player1.get();
    const callerAddr = player1PrivKey.toPublicKey();
    const gameStake = this.gameStake.get();
    const oddRange = this.oddRange.get();
    callerAddr.assertEquals(player1);
    let isCorrect = Circuit.if(
      theOdd.gt(1).and(theOdd.lte(oddRange)),
      Bool(true),
      Bool(false)
    );
    isCorrect.assertEquals(true);
    this.balance.addInPlace(new UInt64(gameStake));
    this.hashedOdd.set(Poseidon.hash([theOdd.add(gameStake)]));
  }
  @method reveal(theOdd: Field, player2PrivKey: PrivateKey) {
    const player1 = this.player1.get();
    const player2 = this.player2.get();
    const callerAddr = player2PrivKey.toPublicKey();
    const gameStake = this.gameStake.get();
    callerAddr.assertEquals(player2);
    let hashedOdd = this.hashedOdd.get();
    let winner = Circuit.if(
      hashedOdd.equals(Poseidon.hash([theOdd.add(gameStake)])),
      callerAddr,
      player1
    );
    this.winner.set(winner);
  }
  @method payout(winnerKey: PrivateKey) {
    const isPayoutReady = this.isPayoutReady.get();
    isPayoutReady.assertEquals(true);
    const winner = this.winner.get();
    const callerAddr = winnerKey.toPublicKey();
    winner.assertEquals(callerAddr);
    const gameStake = this.gameStake.get();
    this.balance.subInPlace(new UInt64(gameStake));
    this.isPayoutReady.set(Bool(false));
    this.gameStake.set(Field.zero);
  }
}
