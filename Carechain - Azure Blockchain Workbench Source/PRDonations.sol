pragma solidity ^0.4.20;

contract WorkbenchBase {
    event WorkbenchContractCreated(string applicationName, string workflowName, address originatingAddress);
    event WorkbenchContractUpdated(string applicationName, string workflowName, string action, address originatingAddress);

    string internal ApplicationName;
    string internal WorkflowName;

    function WorkbenchBase(string applicationName, string workflowName) internal {
        ApplicationName = applicationName;
        WorkflowName = workflowName;
    }

    function ContractCreated() internal {
        WorkbenchContractCreated(ApplicationName, WorkflowName, msg.sender);
    }

    function ContractUpdated(string action) internal {
        WorkbenchContractUpdated(ApplicationName, WorkflowName, action, msg.sender);
    }
}

contract ProcessDonation is WorkbenchBase('PRDonations', 'ProcessDonation') {

     //Set of States
    enum StateType { Request, Respond}

    //List of properties
    StateType public  State;
    address public  Processor;
    address public  Receiver;
    
    string public  Status;
    string public  Amount;
    string public  Destination;
    string public RequestMessage;
    string public ResponseMessage;

    // constructor function
    function ProcessDonation(string message, string amount, string destination, string status) public
    {
        Processor = msg.sender;
        RequestMessage = message;
        State = StateType.Request;
        Status = status;
        Destination = destination;
        Amount = amount;
        // call ContractCreated() to create an instance of this workflow
        ContractCreated();
    }

    // call this function to send a request
    function SendRequest(string requestMessage, string requestStatus, string requestDestination, string requestAmount) public
    {
        if (Receiver != msg.sender)
        {
            revert();
        }

        RequestMessage = requestMessage;
        State = StateType.Request;
        Status = requestStatus;
        Destination = requestDestination;
        Amount = requestAmount;

        // call ContractUpdated() to record this action
        ContractUpdated('SendRequest');
    }

    // call this function to send a response
    function SendResponse(string responseMessage, string responseStatus) public
    {
        Receiver = msg.sender;

        ResponseMessage = responseMessage;
        State = StateType.Respond;
        Status = responseStatus;
     
        // call ContractUpdated() to record this action
        ContractUpdated('SendResponse');
    }
}
