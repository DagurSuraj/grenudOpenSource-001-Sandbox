public class FieldVisitTriggerHandler
{
  public static void PopulateFieldVisitName(List<Field_Visit__c> NewKitScheduleList)
    {
        Set<ID>FarmName=new set<ID>();
        for (Field_Visit__c KSObj : NewKitScheduleList) 
        {
            if (KSObj.Farm_Name__c != null)
            {
                FarmName.add(KSObj.Farm_Name__c);
            }
        }   
        Map<Id,Farm__c>FarmMap= new Map<Id,Farm__c>([Select Id,Name from Farm__c where ID IN : FarmName]);
        system.debug(FarmMap);
        list<Field_Visit__c>LastKitSchedule=[select Id,Name,Series__c from Field_Visit__c where Farm_Name__c IN : FarmName Order BY series__c DESC LIMIT 1 ];
        if(LastKitSchedule.size()==0)
        {
             for(Field_Visit__c KSObj : NewKitScheduleList){
                 
                if(KSObj.Farm_Name__c != null)
                {
                     {
                         Farm__c farm = farmMap.get(KSObj.Farm_Name__c);
                         KSObj.Series__c=1;//integer.valueof(NewKitScheduleList.indexof(KSObj));
                         system.debug(KSObj.Series__c);
                         KSObj.Name = farm.Name +'' + 'FV'+1;
                     }
                }
             }
        }      
        else
        {
           for(Field_Visit__c KSObj : NewKitScheduleList){
                 
                if(KSObj.Farm_Name__c != null)
                {
                     {
                         Farm__c farm = farmMap.get(KSObj.Farm_Name__c);
                         KSObj.Series__c=LastKitSchedule[0].series__c+1;
                         KSObj.Name = farm.Name +'' + 'FV'+  string.valueof(KSObj.Series__c);    //LastKitSchedule[0].series__c;
                     }
                }
             } 
        }
    }
    
     public static void updateFieldVistFields(List<Field_Visit__c>FieldVisitList)
    {
        Set<Id> farmIds = new Set<Id>();
        for (Field_Visit__c KSObj : FieldVisitList) 
        {
            if (KSObj.Farm_Name__c != null)
            {
                farmIds.add(KSObj.Farm_Name__c);
            }
        }            
        if (!farmIds.isEmpty())
        {
            Map<Id, Farm__c> farmsMap = new Map<Id, Farm__c>([SELECT Id, Client_Farmer__c,Father_Name__c, Village__c,District__c, Block__c FROM Farm__c WHERE Id IN :farmIds]);
            for (Field_Visit__c KSObj : FieldVisitList) 
            {
                if (KSObj.Farm_Name__c != null) 
                {
                    Farm__c farm = farmsMap.get(KSObj.Farm_Name__c);
                    if (farm != null) 
                    {
                        KSObj.Client_Farmer__c = farm.Client_Farmer__c;
                        KSObj.Father_Name__c=farm.Father_Name__c;
                        KSObj.Village__c = farm.Village__c;
                        KSObj.Block__c = farm.Block__c;
                        KSObj.District__c=farm.District__c;
                     }
                }
            }
        }
    }
    
     public static void preventDuplicateFieldVisit(List<Field_Visit__c> newVisits) {
        Set<Id> uniqueFarmIds = new Set<Id>();
        Map<Id, Date> farmIdToLatestDateMap = new Map<Id, Date>();
        
        for (Field_Visit__c visit : newVisits) {
            if (visit.Farm_Name__c != null) {
                uniqueFarmIds.add(visit.Farm_Name__c);
            }
        }

        if (!uniqueFarmIds.isEmpty()) {
            List<Field_Visit__c> existingVisits = [
                SELECT Id, CreatedDate, Farm_Name__c 
                FROM Field_Visit__c 
                WHERE Farm_Name__c IN :uniqueFarmIds
            ];

            for (Field_Visit__c existingVisit : existingVisits) {
                Date existingCreatedDate = existingVisit.CreatedDate.dateGMT(); // Get the date part only, ignoring the time.
                if (!farmIdToLatestDateMap.containsKey(existingVisit.Farm_Name__c) || existingCreatedDate > farmIdToLatestDateMap.get(existingVisit.Farm_Name__c)) {
                    farmIdToLatestDateMap.put(existingVisit.Farm_Name__c, existingCreatedDate);
                }
            }
        }

        for (Field_Visit__c newVisit : newVisits) {
            if (newVisit.Farm_Name__c != null) {
                Date newCreatedDate = DateTime.now().dateGMT(); // Get the current date part in GMT
                if (farmIdToLatestDateMap.containsKey(newVisit.Farm_Name__c) &&
                    newCreatedDate == farmIdToLatestDateMap.get(newVisit.Farm_Name__c)) {
                    newVisit.addError('Only one Field Visit record is allowed per day for each Farm record.');
                }
            }
        }
    }
}