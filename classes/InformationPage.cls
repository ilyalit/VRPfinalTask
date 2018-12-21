/**
 * Created by Илья on 10.12.2018.
 */

public with sharing class InformationPage {
    public Stock__c newRecord{get;set;}
    public Stock__c retriveId {get;set;}
    public Boolean popUpStatus{get;set;}
    public Stock__c existRecord {get;set;}
    //---------PAGINATION VARIABLES---------
    public integer counter=0;  //keeps track of the offset
    private integer list_size=13; //sets the page size or number of rows
    public integer total_size=0; //used to show user the total size of the list
    //-------------SORT VARIABLES-------------
    public String sortField {get;set;}
    public String myOrder {get;set;}

    public String searchByName{get;set;}

    public InformationPage(){
        newRecord = new Stock__c();
        retriveId = new Stock__c();
        existRecord = new Stock__c();
        sortField = 'Name';
        myOrder = 'ASC';
        searchByName = '';
    }
    public void deleteRecord(){
        try{
            delete retriveId;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Record Deleted!');
            ApexPages.addMessage(myMsg);
        }catch (DmlException e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: '+e.getMessage());
            ApexPages.addMessage(myMsg);
        }
    }
    public void closePopup() {
        popUpStatus = false;
        existRecord = new Stock__c();
    }
    public void showPopup() {
        if(existRecord.Id != null){
        List<Stock__c> record = [SELECT Id, Name, Add_Date__c, Amount__c, Date_of_issue__c, In_stock__c, Price__c, Type__c
                                 FROM Stock__c WHERE Id=:existRecord.Id];
        existRecord.Name = record[0].Name;
        existRecord.Add_Date__c = record[0].Add_Date__c;
        existRecord.Amount__c = record[0].Amount__c;
        existRecord.Date_of_issue__c = record[0].Date_of_issue__c;
        existRecord.In_stock__c = record[0].In_stock__c;
        existRecord.Price__c = record[0].Price__c;
        existRecord.Type__c = record[0].Type__c;
        }
        popUpStatus = true;
    }
    public void savePopUp(){
        if(Date.today() < existRecord.Date_of_issue__c){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Invalid Date of Issue');
            ApexPages.addMessage(myMsg);
            popUpStatus = false;
        }else{
            try{
                if(existRecord.Id != null){
                    update existRecord;
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Record Updated!');
                    ApexPages.addMessage(myMsg);
                }else{
                    insert existRecord;
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Record Inserted!');
                    ApexPages.addMessage(myMsg);
                }
                //upsert existRecord;
                existRecord=null;
                existRecord = new Stock__c();
                popUpStatus = false;
            }catch (DmlException e){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: '+e.getMessage());
                ApexPages.addMessage(myMsg);
            }
        }
    }
    //---------------------------------------------PAGINATION-----------------------------------------------------
    //------------------------------------------------------------------------------------------------------------
    public List<Stock__c> getProducts() {
        try {
            String q = 'Select Id, Name, Add_Date__c, Amount__c, Date_of_issue__c, In_stock__c, Price__c, Type__c From Stock__c ';
            if(searchByName == ''){
                System.debug('searchByName in not empty');
                q += ' Order by ' +  String.escapeSingleQuotes(sortField) + ' ' + myOrder + ' LIMIT ' + list_size + ' OFFSET ' + counter;
                total_size = [select count() from Stock__c];
            } else{
                q += ' WHERE Name LIKE \'%' + String.escapeSingleQuotes(searchByName)+'%\'' + ' Order by ' +  String.escapeSingleQuotes(sortField) + ' ' + myOrder + ' LIMIT ' + list_size + ' OFFSET ' + counter;
                total_size = database.countQuery('SELECT count() FROM Stock__c ' + 'WHERE Name LIKE \'%' + String.escapeSingleQuotes(searchByName)+'%\'');
            }
            return Database.query(q);
        } catch (QueryException e) {
            ApexPages.addMessages(e);
            return null;
        }
    }
    public PageReference Beginning() { //user clicked beginning
        counter = 0;
        return null;
    }

    public PageReference Previous() { //user clicked previous button
        counter -= list_size;
        return null;
    }
    public PageReference Next() { //user clicked next button
        counter += list_size;
        return null;
    }
    public PageReference End() { //user clicked end
        counter = total_size - math.mod(total_size, list_size);
        return null;
    }
    public Boolean getDisablePrevious() {
        //this will disable the previous and beginning buttons
        if (counter>0) return false; else return true;
    }
    public Boolean getDisableNext() { //this will disable the next and end buttons
        if (counter + list_size < total_size) return false; else return true;
    }
    public Integer getTotal_size() {
        return total_size;
    }
    public Integer getPageNumber() {
        return counter/list_size + 1;
    }
    public Integer getTotalPages() {
        if (math.mod(total_size, list_size) > 0) {
            return total_size/list_size + 1;
        } else {
            return (total_size/list_size);
        }
    }
}