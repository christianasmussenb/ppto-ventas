Class Config.ActionCatalog Extends %Persistent
{

Property ActionCode As %String(MAXLEN = 50) [ Required ];
Property ActionName As %String(MAXLEN = 100);
Property Channel As %String(MAXLEN = 20);
Property Description As %String(MAXLEN = 500);
Property IsActive As %Boolean [ InitialExpression = 1 ];

Index ActionCodeIdx On ActionCode [ Unique ];

Storage Default
{
<Data name="ActionCatalogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ActionCode</Value>
</Value>
<Value name="3">
<Value>ActionName</Value>
</Value>
<Value name="4">
<Value>Channel</Value>
</Value>
<Value name="5">
<Value>Description</Value>
</Value>
<Value name="6">
<Value>IsActive</Value>
</Value>
</Data>
<DataLocation>^Config.ActionCatalogD</DataLocation>
<DefaultData>ActionCatalogDefaultData</DefaultData>
<IdLocation>^Config.ActionCatalogD</IdLocation>
<IndexLocation>^Config.ActionCatalogI</IndexLocation>
<StreamLocation>^Config.ActionCatalogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
