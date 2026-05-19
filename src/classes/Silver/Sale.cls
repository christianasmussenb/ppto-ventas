Class Silver.Sale Extends %Persistent
{

Property SaleId As %String(MAXLEN = 80) [ Required ];
Property SaleTimestamp As %TimeStamp [ Required ];
Property StoreCode As %String(MAXLEN = 20) [ Required ];
Property InternalSKU As %String(MAXLEN = 50) [ Required ];
Property Qty As %Integer;
Property Price As %Numeric;
Property CategoryCode As %String(MAXLEN = 50);
Property SourceEventId As %String(MAXLEN = 80);

Index SaleIdIdx On SaleId [ Unique ];

Storage Default
{
<Data name="SaleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SaleId</Value>
</Value>
<Value name="3">
<Value>SaleTimestamp</Value>
</Value>
<Value name="4">
<Value>StoreCode</Value>
</Value>
<Value name="5">
<Value>InternalSKU</Value>
</Value>
<Value name="6">
<Value>Qty</Value>
</Value>
<Value name="7">
<Value>Price</Value>
</Value>
<Value name="8">
<Value>CategoryCode</Value>
</Value>
<Value name="9">
<Value>SourceEventId</Value>
</Value>
</Data>
<DataLocation>^Silver.SaleD</DataLocation>
<DefaultData>SaleDefaultData</DefaultData>
<IdLocation>^Silver.SaleD</IdLocation>
<IndexLocation>^Silver.SaleI</IndexLocation>
<StreamLocation>^Silver.SaleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
