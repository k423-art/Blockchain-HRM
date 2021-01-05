pragma solidity >=0.4.21 <0.71.0;

contract BlockChainHRM {
    uint32 public job_id = 0;
    uint32 public worker_id = 0;
    uint32 public factory_id = 0;
    
    struct job {
        string modelNumber;
        string partNumber;
        string serialNumber;
        address jobFactory;
        uint32 cost;
        uint32 mfgTimeStamp;
    }
    
    mapping(uint32 => job) public jobs;
    
    struct worker {
        string userName;
        string password;
        string workerType;
        address workerAddress;
    }
    mapping(uint32 => worker) public workers;
     
    struct factoryship {
        uint32 jobId;
        uint32 factoryId;
        uint32 trxTimeStamp;
        address jobFactory;
    }
    mapping(uint32 => factoryship) public factoryships;
    mapping(uint32 => uint32[]) public jobTrack;
    
    event TransferFactoryship(uint32 jobId);
     
    function addWorker(string memory _name, string memory _pass,address _pAdd,string memory _pType) public returns (uint32){
        uint32 userId = worker_id++;
        workers[userId].userName = _name ;
        workers[userId].password = _pass ;
        workers[userId].workerAddress = _pAdd;
        workers[userId].workerType = _pType;
        
        return userId;
    }
    
    function getWorker(uint32 _worker_id) public view returns(string memory,address,string memory) {
        return (workers[_worker_id].userName,
                workers[_worker_id].workerAddress,
                workers[_worker_id].workerType);
    }
    
     function addJob(uint32 _factoryId,
                        string memory _modelNumber,
                        string memory _partNumber,
                        string memory _serialNumber,
                        uint32 _jobCost) public returns (uint32) {
        if(keccak256(abi.encodePacked (workers[_factoryId].workerType)) == keccak256("Manufacturer")) {
            uint32 jobId = job_id++;
            
            jobs[jobId].modelNumber = _modelNumber;
            jobs[jobId].partNumber = _partNumber;
            jobs[jobId].serialNumber = _serialNumber;
            jobs[jobId].cost = _jobCost;
            jobs[jobId].jobFactory = workers[_factoryId].workerAddress;
            jobs[jobId].mfgTimeStamp = uint32(block.timestamp);
    
            return jobId;
        }
    
        return 0;  
    }
    
    modifier onlyfactory (uint32 _jobId) {
        require(msg.sender == jobs[_jobId].jobFactory, "");
        _;
        
    }
    
    function getProduct(uint32 _jobId) public view returns (string memory, string memory,string memory, uint32, address, uint32){
        return (jobs[_jobId].modelNumber,
                jobs[_jobId].partNumber,
                jobs[_jobId].serialNumber,
                jobs[_jobId].cost,
                jobs[_jobId].jobFactory ,
                jobs[_jobId].mfgTimeStamp);
    }
    
    function newFactory (uint32 _user1Id,uint32 _user2Id, uint32 _jobId) onlyfactory(_jobId) public returns(bool) {
        worker memory p1 = workers[_user1Id];
        worker memory p2 = workers[_user2Id];
        uint32 factoryship_id = factory_id++;
    
        if(keccak256(abi.encodePacked(p1.workerType)) == keccak256 ("Manufacturer")
            && keccak256(abi.encodePacked (p2.workerType)) == keccak256("HRM")) {
            factoryships[factoryship_id].jobId = _jobId;
            factoryships[factoryship_id].jobFactory = p2.workerAddress;
            factoryships[factoryship_id].factoryId = _user2Id;
            factoryships[factoryship_id].trxTimeStamp = uint32(block.timestamp);
            jobs[_jobId].jobFactory = p2.workerAddress;
            jobTrack[_jobId].push(factoryship_id);
            emit TransferFactoryship( _jobId);
            
            return (true);
        }
        else if(keccak256(abi.encodePacked (p1.workerType)) == keccak256("HRM") && keccak256(abi.encodePacked(p2.workerType))==keccak256("HRM")) {
            factoryships[factoryship_id].jobId = _jobId;
            factoryships[factoryship_id].jobFactory = p2.workerAddress;
            factoryships[factoryship_id].factoryId = _user2Id;
            factoryships[factoryship_id].trxTimeStamp = uint32(block.timestamp);
            jobs[_jobId].jobFactory = p2.workerAddress;
            jobTrack[_jobId].push(factoryship_id);
            emit TransferFactoryship( _jobId);
            
            return (true);
        }
         else if(keccak256(abi.encodePacked (p1.workerType)) == keccak256("HRM") && keccak256(abi.encodePacked(p2.workerType))==keccak256("HRM")){
            factoryships[factoryship_id].jobId = _jobId;
            factoryships[factoryship_id].jobFactory = p2.workerAddress;
            factoryships[factoryship_id].factoryId = _user2Id;
            factoryships[factoryship_id].trxTimeStamp = uint32(block.timestamp);
            jobs[_jobId].jobFactory = p2.workerAddress;
            jobTrack[_jobId].push(factoryship_id);
            emit TransferFactoryship( _jobId);
            
            return (true);
        }
        
        return (false);
    }
    
    function getProvenance(uint32 _jobId) external view returns (uint32[] memory) {
    
        return jobTrack[_jobId];
    }
    
    function getFactoryship(uint32 _regId) public view returns(uint32,uint32, address, uint32) {
    
        factoryship memory r = factoryships[_regId];

         return (r.jobId, r.factoryId, r.jobFactory,r.trxTimeStamp);
    }
    
    function authenticateWorker (uint32 _uid,
                                    string memory _uname,
                                    string memory _pass,
                                    string memory _utype) public view returns(bool) {
        if(keccak256(abi.encodePacked (workers[_uid].workerType)) == keccak256(abi.encodePacked(_utype))) {
            if(keccak256(abi.encodePacked (workers[_uid].userName)) == keccak256(abi.encodePacked(_uname))) {
                if(keccak256(abi.encodePacked(workers[_uid].password)) == keccak256(abi.encodePacked(_pass))) {
                     return (true);
                }
            }
        }
        
        return (false);
    }
}