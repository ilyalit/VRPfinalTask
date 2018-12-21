/**
 * Created by Илья on 20.12.2018.
 */

@IsTest
private class Test_InformationPage {
    @testSetup static void setup() {
        List<Stock__c> testStocks = new List<Stock__c>();
        for(Integer i=0;i<10;i++) {
            testStocks.add(new Stock__c(Name = 'TestProd'+i));
        }
        insert testStocks;
    }

    @isTest public static void deleteTest(){
        List<Stock__c> allTestProducts = [SELECT id, name FROM Stock__c];
        InformationPage a = new InformationPage();
        a.retriveId.id = allTestProducts[0].id;
        a.deleteRecord();
        List<Stock__c> allTestProductsAfterDelete = [SELECT id, name FROM Stock__c];
        System.assertEquals(9,allTestProductsAfterDelete.size());
    }
    @isTest public static void deleteTestWithExeption(){
        InformationPage a = new InformationPage();
        List<Stock__c> allTestProducts = [SELECT id, name FROM Stock__c];
        a.retriveId.Id = allTestProducts[0].Id;
        delete a.retriveId;
        a.deleteRecord();
//        a.existRecord.Id = a.retriveId.Id;
//        a.savePopUp();
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        System.assertNotEquals(0, pageMessages.size());
    }
    @isTest public static void closePopupTest(){
        InformationPage a = new InformationPage();
        a.closePopup();
        System.assertEquals(false,a.popUpStatus);
    }
    @isTest public static void showPopupTest(){
        List<Stock__c> allTestProducts = [SELECT id, name FROM Stock__c];
        InformationPage a = new InformationPage();
        a.existRecord.id = allTestProducts[0].id;
        a.showPopup();
        System.assertEquals(allTestProducts[0].name,a.existRecord.name);
        System.assertEquals(true,a.popUpStatus);
    }
    @isTest public static void savePopUpTestEdit(){
        List<Stock__c> allTestProducts = [SELECT id, name FROM Stock__c];
        InformationPage a = new InformationPage();
        a.existRecord.id = allTestProducts[0].id;
        a.existRecord.name = 'Kiss';
        a.savePopUp();
        List<Stock__c> editedProduct = [SELECT id, name FROM Stock__c WHERE name ='Kiss'];
        System.assertEquals(1, editedProduct.size());
    }
    @isTest public static void savePopUpTestAdd(){
        InformationPage a = new InformationPage();
        a.existRecord.name = 'Kiss';
        a.savePopUp();
        List<Stock__c> editedProduct = [SELECT id, name FROM Stock__c WHERE name ='Kiss'];
        System.assertEquals(1, editedProduct.size());
    }
    @isTest public static void savePopUpTestWrongDate(){
        InformationPage a = new InformationPage();
        a.existRecord.Date_of_issue__c = Date.today().addDays(1);
        a.savePopUp();
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        System.assertNotEquals(0, pageMessages.size());
    }
    @isTest public static void getProducts_Test(){
        InformationPage a = new InformationPage();
        List<Stock__c> allProducts = a.getProducts();
        System.assertEquals(10, allProducts.size());
    }
    @isTest public static void getProductsWithSearch_Test(){
        InformationPage a = new InformationPage();
        a.searchByName = 'error';
        List<Stock__c> allProducts = a.getProducts();
        System.assertEquals(0, allProducts.size());
    }
    @isTest public static void getProductsWithQueryExeption_Test(){
        InformationPage a = new InformationPage();
        a.counter = -1;
        a.getProducts();
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        System.assertNotEquals(0, pageMessages.size());
    }
    @isTest public static void buttons_Test(){
        InformationPage a = new InformationPage();

        PageReference result = a.Beginning();
        System.assertEquals(null, result);
        System.assertEquals(0, a.counter);

        result = a.Previous();
        System.assertEquals(null, result);
        System.assertEquals(-13, a.counter);

        result = a.Next();
        System.assertEquals(null, result);
        System.assertEquals(0, a.counter);

        result = a.End();
        System.assertEquals(null, result);
        System.assertEquals(0, a.counter);

        Boolean resultsBool = a.getDisablePrevious();
        System.assertEquals(true, resultsBool);

        resultsBool = a.getDisableNext();
        System.assertEquals(true, resultsBool);

        Integer resultsInt = a.getTotal_size();
        System.assertEquals(0, resultsInt);

        resultsInt = a.getPageNumber();
        System.assertEquals(1, resultsInt);

        resultsInt = a.getTotalPages();
        System.assertEquals(0, resultsInt);
    }
    @isTest public static void Trigger_test(){
        List<Stock__c> newProds = new List<Stock__c>();
        newProds.add(new Stock__c(Name = 'newProdWithAmount', Amount__c = 3));
        newProds.add(new Stock__c(Name = 'newProdWithOutAmount', Amount__c = 0));
        insert  newProds;
        List<Stock__c> recentlyInserted = [SELECT In_stock__c FROM Stock__c WHERE Name LIKE '%newProdWith%'];
        System.assertEquals(true, recentlyInserted[0].In_stock__c);
        System.assertEquals(false, recentlyInserted[1].In_stock__c);

    }
}