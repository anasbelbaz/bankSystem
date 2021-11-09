const { BN, expectEvent, expectRevert } = require('@openzeppelin/test-helpers')
const { expect } = require('chai')
const Bank = artifacts.require('Bank')

contract('Bank', (accounts) => {
  const owner = accounts[0]
  const recipient = accounts[1]
  const spender = accounts[2]
  let bankInstance

  beforeEach(async () => {
    bankInstance = await Bank.new({ from: owner })
  })

  it('... should revert', async () => {
    const amount = 1

    await expectRevert(
      bankInstance.sendEth({ from: owner, value: amount }),
      'Not enough Wei.'
    )
  })

  it('... should send ether', async () => {
    const amount = 10

    const receipt = await bankInstance.sendEth({ from: owner, value: amount })
    const balance = await bankInstance.getBalance.call()
    expect(balance).to.be.bignumber.equal(new BN(amount))

    expectEvent(receipt, 'argentDepose', { value: new BN(amount) })
  })

  it('... should get balance', async () => {
    const balance = await bankInstance.getBalance.call()

    expect(balance).to.be.bignumber.equal(new BN(0))
  })
})
