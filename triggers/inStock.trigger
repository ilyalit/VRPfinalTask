trigger inStock on Stock__c (before insert, before update) {
    HandlerBeforeInsert.handlerBeforeInsert(Trigger.new);
}