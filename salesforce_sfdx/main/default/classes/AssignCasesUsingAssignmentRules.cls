public class AssignCasesUsingAssignmentRules {


    @InvocableMethod
    public static void createAndAssignCase(List < Id > orchestrationItemIds) {
        Case fulfillmentCase = new Case();

        %vlocity_namespace%__OrchestrationItem__c orchestrationItem = [select id, name, %vlocity_namespace%__OrchestrationPlanId__r.%vlocity_namespace%__OrderId__r.Id, %vlocity_namespace%__OrchestrationPlanId__r.%vlocity_namespace%__OrderId__r.AccountId from %vlocity_namespace%__OrchestrationItem__c where id in: orchestrationItemIds];

        fulfillmentCase.Status = 'New';
        fulfillmentCase.Priority = 'Medium';
        fulfillmentCase.Subject = 'Fulfillment task failed';
        fulfillmentCase.Description = 'Automatically created case for a failed fulfillment process';
        fulfillmentCase.Origin = 'Vlocity XOM';

        fulfillmentCase.AccountId = orchestrationItem.%vlocity_namespace%__OrchestrationPlanId__r.%vlocity_namespace%__OrderId__r.AccountId;
        fulfillmentCase.Orchestration_Item__c = orchestrationItem.Id;
        fulfillmentCase.Orchestration_Plan__c = orchestrationItem.%vlocity_namespace%__OrchestrationPlanId__r.Id;
        fulfillmentCase.Order__c = orchestrationItem.%vlocity_namespace%__OrchestrationPlanId__r.%vlocity_namespace%__OrderId__r.Id;

        //Fetching the assignment rules on case
        AssignmentRule AR = new AssignmentRule();
        AR = [select id from AssignmentRule where SobjectType = 'Case'
            and Active = true limit 1
        ];

        //Creating the DMLOptions for "Assign using active assignment rules" checkbox
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        dmlOpts.assignmentRuleHeader.assignmentRuleId = AR.id;
        dmlOpts.EmailHeader.triggerUserEmail = true;

        //Setting the DMLOption on Case instance
        fulfillmentCase.setOptions(dmlOpts);
        insert fulfillmentCase;
    }
}