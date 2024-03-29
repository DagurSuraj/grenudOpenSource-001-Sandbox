trigger PaddyPurchaseTrigger on Paddy_Purchase__c (before insert,before update,after insert, after update, after delete, after undelete) 
{   
        if(trigger.isbefore && trigger.isInsert)
        {
           PaddyPurchaseTriggerHandler.handleBeforeInsertInvoice(trigger.new);
            PaddyPurchaseTriggerHandler.convertToWord( trigger.new);
        }
    
        if(trigger.isbefore && trigger.isupdate)
        {
            PaddyPurchaseTriggerHandler.handleBeforeUpdateInvoice(trigger.new,Trigger.oldMap);
            PaddyPurchaseTriggerHandler.convertToWord( trigger.new );
        }
    
        if (Trigger.isAfter && Trigger.isInsert)
        {
           
           PaddyPurchaseTriggerHandler.handleUpdateMasterLooseQuantity(Trigger.new);
           PaddyPurchaseTriggerHandler.updateCreditSettlementRollupSum(trigger.new);
           PaddyPurchaseTriggerHandler.updateGrandTotalRollupSum(trigger.new);
            PaddyPurchaseTriggerHandler.updateAmountSupplyBillRollupSum(Trigger.new);
        } 
        if (Trigger.isAfter && Trigger.isUpdate) 
        {
            //PaddyPurchaseTriggerHandler.UpdateSaleAttempFieldforLooseMaster(trigger.oldMap, trigger.newMap);
           PaddyPurchaseTriggerHandler.handleReparentingLooseMaster(trigger.old, trigger.new, trigger.oldmap);
           PaddyPurchaseTriggerHandler.updateReparentCreditSettRollUpSum(trigger.old, trigger.new, trigger.oldmap);
           PaddyPurchaseTriggerHandler.updateReparentGrandTotalRollUpSum(trigger.old, trigger.new, trigger.oldmap);
           PaddyPurchaseTriggerHandler.updateReparentSupplyBillingAmountRollUpSum(trigger.old, trigger.new, trigger.oldmap);
            
        } 
        if (Trigger.isAfter && Trigger.isDelete) 
        {
            PaddyPurchaseTriggerHandler.handleUpdateMasterLooseQuantity(Trigger.old);
            PaddyPurchaseTriggerHandler.updateCreditSettlementRollupSum(trigger.old);
            PaddyPurchaseTriggerHandler.updateGrandTotalRollupSum(trigger.old);
            PaddyPurchaseTriggerHandler.updateAmountSupplyBillRollupSum(trigger.old);
        } 
        if (Trigger.isAfter && Trigger.isUndelete)
        {
          PaddyPurchaseTriggerHandler.handleUpdateMasterLooseQuantity(Trigger.new);
          PaddyPurchaseTriggerHandler.updateCreditSettlementRollupSum(trigger.new);
          PaddyPurchaseTriggerHandler.updateGrandTotalRollupSum(trigger.new);
          PaddyPurchaseTriggerHandler.updateAmountSupplyBillRollupSum(trigger.new); 
        }    
}