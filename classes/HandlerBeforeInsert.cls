public class HandlerBeforeInsert {
    public static void handlerBeforeInsert(List<Stock__c> newProduct){
        List<Stock__c> newProds = new List<Stock__c>();
        for(Stock__c newProd : newProduct){
            if(newProd.Amount__c > 0){
                newProd.In_stock__c = true;
            }else{
                newProd.In_stock__c = false;
            }
        }
    }

}