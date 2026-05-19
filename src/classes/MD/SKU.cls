Class MD.SKU Extends %Persistent
{

Property InternalSKU As %String(MAXLEN = 50) [ Required ];
Property VendorSKU As %String(MAXLEN = 50);
Property CategoryCode As %String(MAXLEN = 50);
Property UnitOfMeasure As %String(MAXLEN = 20);

Index InternalSKUIdx On InternalSKU [ Unique ];

Storage Default
{
<Data name="SKUDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InternalSKU</Value>
</Value>
<Value name="3">
<Value>VendorSKU</Value>
</Value>
<Value name="4">
<Value>CategoryCode</Value>
</Value>
<Value name="5">
<Value>UnitOfMeasure</Value>
</Value>
</Data>
<DataLocation>^MD.SKUD</DataLocation>
<DefaultData>SKUDefaultData</DefaultData>
<IdLocation>^MD.SKUD</IdLocation>
<IndexLocation>^MD.SKUI</IndexLocation>
<StreamLocation>^MD.SKUS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
