Var ; SupplyChain = artifacts.require("./BlockChainHRM.sol");
contract('BlockChainHRM', async accounts =>{
    it("工厂入驻", async () => {
        let instance = await BlockChainHRM.deployed();
        let participantId = await instance.addParticipant("A", "passA", "0xa374F5707c662790D8b1e4A6FDB8Ba051Ef43934", "Manufacturer");
        let participant = await instance.participants(0);
        assert.equal(participant[0],"A");
        assert.equal(participant[2],"Manufacturer");
    });

    it("发布招聘需求", async () => {
        let instance = await BlockChainHRM.deployed();
        let prodId1 = await instance.addProduct(0,"招聘需求","100","123",11);
        let prod1 = await instance.getProduct(0);
        assert.equal(prod1[0],"招聘需求", "==>"+prod1[0].modelNumber);
    })
    
    it("newOwn", async () => {
        let instance = await BlockChainHRM.deployed();
        await instance.newOwner(0, 1, 0, { from: "0xa374F5707c662790D8b1e4A6FDB8Ba051Ef43934"});
        let _getOwnership = await instance._getOwnership(0)
        console.log("_getOwnership", _getOwnership[2]);

        assert.equal("0x26f5Da1Ab2Ac454a5a7059090c79403b359dF2c5", _getOwnership[2]);
        

    })
})