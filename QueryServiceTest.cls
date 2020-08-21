@isTest
public class QueryServiceTest {

    @TestSetup
    static void makeData(){
        Account acc = new Account(
            Name = 'test'
        );

        insert acc;
    }

    @isTest
    static void buildQueryString(){
        String expectedString = 'SELECT Id, Name FROM Account WHERE Name = \'john\' ORDER BY Name DESC LIMIT 10';
        
        Test.startTest();
        String queryString = new QueryService().selectFields('Id, Name')
                                               .fromObject(Account.SObjectType)
                                               .whereFilter('Name = \'john\'')
                                               .orderBy('Name').setDESC()
                                               .setLIMIT(10)
                                               .getAsString();
        Test.stopTest();

        System.assert(expectedString.equalsIgnoreCase(queryString), 'expected the two query to be the same' );
    }

    @isTest
    static void executeGlobalQuery(){
        Test.startTest();
        List<Account> accounts =  (List<Account>) new QueryService().selectAllFieldsFrom(Account.SObjectType)
                                                                    .addRelatedFields('CreatedBy.Name, CreatedBy.Profile.Name')
                                                                    .whereFilter('Name = \'test\'')
                                                                    .orderBy('CreatedDate').setASC()
                                                                    .setLIMIT(5)
                                                                    .execute();
        Test.stopTest();
        
        System.assert(accounts.size() == 1, 'expected 1 account');

    }
}
