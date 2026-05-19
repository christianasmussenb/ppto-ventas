Class MD.Store Extends %Persistent
{

Property StoreCode As %String(MAXLEN = 20) [ Required ];
Property StoreName As %String(MAXLEN = 100);
Property Region As %String(MAXLEN = 50);
Property District As %String(MAXLEN = 50);
Property TimeZone As %String(MAXLEN = 50);

Index StoreCodeIdx On StoreCode [ Unique ];

Storage Default
{
<Data name="StoreDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StoreCode</Value>
</Value>
<Value name="3">
<Value>StoreName</Value>
</Value>
<Value name="4">
<Value>Region</Value>
</Value>
<Value name="5">
<Value>District</Value>
</Value>
<Value name="6">
<Value>TimeZone</Value>
</Value>
</Data>
<DataLocation>^MD.StoreD</DataLocation>
<DefaultData>StoreDefaultData</DefaultData>
<IdLocation>^MD.StoreD</IdLocation>
<IndexLocation>^MD.StoreI</IndexLocation>
<StreamLocation>^MD.StoreS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
