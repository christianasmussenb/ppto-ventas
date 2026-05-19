Class MD.Category Extends %Persistent
{

Property CategoryCode As %String(MAXLEN = 50) [ Required ];
Property CategoryName As %String(MAXLEN = 100);

Index CategoryCodeIdx On CategoryCode [ Unique ];

Storage Default
{
<Data name="CategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CategoryCode</Value>
</Value>
<Value name="3">
<Value>CategoryName</Value>
</Value>
</Data>
<DataLocation>^MD.CategoryD</DataLocation>
<DefaultData>CategoryDefaultData</DefaultData>
<IdLocation>^MD.CategoryD</IdLocation>
<IndexLocation>^MD.CategoryI</IndexLocation>
<StreamLocation>^MD.CategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
