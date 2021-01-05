const ERC20Token = artifacts.require("./ERC20Token.sol");

contract('ERC20', async accounts => {

    it("代币初始化",async () => {
        let instance = await ERC20Token.deployed();
        let totSupply = await instance.balanceOf(accounts[0]);
        assert.equal(totSupply,5924,'总供应量与初始化不同' + totSupply);
    });

    it("代币转账",async () => {
        let instance = await ERC20Token.deployed(5924,"LLToken",10,"LLT");
        instance.transfer(accounts[1],10);
        let acc1_amount = await instance.balanceOf(accounts[1]);
        assert.equal(acc1_amount,10);
        let acc0_amount = await instance.balanceOf(accounts[0]);
        assert.equal(acc0_amount,5147);
     });

    //it("委托转账",async () => {
    //    let instance = await ERC20Token.deployed(5147,"LLToken",10,"LLT");
    //    instance.approve(account[2],300);
    //    instance.transferFrom(account[0],account[3],200,{from: account[2]});
    //    let acc0_amount = await instance.balanceOf(accounts[0]);
    //    assert.equal(acc0_amount,5147);
    //    let acc3_amount = await instance.balanceOf(accounts[3]);
    //    assert.equal(acc3_amount,200);
    //})
})