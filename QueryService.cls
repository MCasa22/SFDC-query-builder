/**
 *  This class uses the Builder Pattern in order to allow the building of a query and its execution.
 *  Examples:
 *  1.  Build a query with all the record's fields and add a few more from a parent object:
 *      List<Account> accounts = (List<Account>) new QueryService().selectAllFieldsFrom(Account.SObjectType)
 *                                                                 .addRelatedFields('CreatedBy.Name, CreatedBy.Profile.Name')
 *                                                                 .setLIMIT(10)
 *                                                                 .execute();
 * 
 *  2.  Build a generic query and have it returned as a string:
 *      String queryString = new QueryService().selectFields('Id, Name')
 *                                             .fromObject(Account.SObjectType)
 *                                             .whereFilter('Name = \'john\'')
 *                                             .orderBy('Name').setDESC()
 *                                             .getAsString();
 * 
 */
public without sharing class QueryService {

    private String queryString;

    private final String FROM_CONDITION         = ' FROM ';
    private final String WHERE_CONDITION        = ' WHERE ';
    private final String ORDERBY_CONDITION      = ' ORDER BY ';
    private final String ASC_CONDITION          = ' ASC';
    private final String DESC_CONDITION         = ' DESC';
    private final String LIMIT_CONDITION        = ' LIMIT ';
    private final String COMMA                  = ', ';

    /**
     *  Constructor.
     *  On new instance, starts query population.
     */
    public QueryService(){
        this.queryString = 'SELECT ';
    }

    /**
     *  Adds the given fields to the query.
     */
    public QueryService selectFields(String fields){
        this.queryString += fields;
        return this;
    }

    /**
     *  Defines the SObjects from which the query starts.
     */
    public QueryService fromObject(Schema.SObjectType sObjectType){
        String sObjectApiName = String.valueOf(sObjectType);
        this.queryString += FROM_CONDITION + sObjectApiName;

        return this;
    }
    
    /**
     *  Adds given filter to the query built so far.
     */
    public QueryService whereFilter(String filters){
        this.queryString += WHERE_CONDITION + filters;

        return this;
    }

    /**
     *  Adds the ORDER BY part to the query built so far.
     */
    public QueryService orderBy(String fieldsToOrderBy){
        this.queryString += ORDERBY_CONDITION + fieldsToOrderBy;

        return this;
    }

    /**
     *  Defines if the ORDER BY is to be ASC.
     */
    public QueryService setASC(){
        this.queryString += ASC_CONDITION;

        return this;
    }

    /**
     *  Defines if the ORDER BY is to be DESC.
     */
    public QueryService setDESC(){
        this.queryString += DESC_CONDITION;

        return this;
    }

    /**
     *  Sets a limit on the record retrieved by the query.
     */
    public QueryService setLIMIT(Integer recordLimit){
        this.queryString += LIMIT_CONDITION + String.valueOf(recordLimit);

        return this;
    }

    /**
     *  Given the SObject Type, retrieves all the fields.
     *  Creates a query logically identical to [SELECT * FROM SObject].
     */
    public QueryService selectAllFieldsFrom(Schema.SObjectType sObjectType){
        String sObjectApiName = String.valueOf(sObjectType);
        Map<String,Schema.SObjectField> fieldsSchema = Schema.getGlobalDescribe().get( sObjectApiName ).getDescribe().fields.getMap();

        List<String> fieldList = new List<String>();
        for(Schema.SObjectField field : fieldsSchema.values()){
            fieldList.add( String.valueOf(field) );
        }
        String fields = String.join(fieldList, ',');
        this.queryString += fields + FROM_CONDITION + sObjectApiName;

        return this;
    }

    /**
     *  Allows adding fields belonging to parent SObjects
     */
    public QueryService addRelatedFields(String lookupFields){
        // finds where the FROM condition is and adds before the related fields
        String queryStringBeforeFROM = this.queryString.substring( 0, this.queryString.indexOf(FROM_CONDITION) );
        String queryStringAfterFROM = this.queryString.substring( this.queryString.indexOf(FROM_CONDITION), this.queryString.length() );

        this.queryString = queryStringBeforeFROM + COMMA + lookupFields + queryStringAfterFROM;

        return this;
    }

    /**
     *  Returns the query built so far as a string.
     */
    public String getAsString(){
        return this.queryString;
    }

    /**
     *  Executes the query built so far and returns the list of SObjects.
     *  Needs to be manually casted.
     */
    public List<SObject> execute(){
        return Database.query(this.queryString);
    }
}
