# SFDC query builder

Independent class for building a query in Salesforce

## Informations

This class allow the creation and execution of normal queries and queries where all fields need to be retrieved.

## Example usage

A normal query can be built as follows:
```apex
// In this example the query is returned as a String
String queryString = new QueryService().selectFields('Id, Name').fromObject(Account.SObjectType)
                                       .whereFilter('Name = \'john\'')
                                       .orderBy('Name').setDESC()
                                       .getAsString();
```


A query with all fields retrieved can be further populated with fields from parent objects:

```apex
List<Account> accounts = (List<Account>) new QueryService().selectAllFieldsFrom(Account.SObjectType)
                                                           .addRelatedFields('CreatedBy.Name, CreatedBy.Profile.Name')
                                                           .setLIMIT(10)
                                                           .execute();
```
