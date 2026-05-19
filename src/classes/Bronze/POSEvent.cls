Class Bronze.POSEvent Extends %Persistent
{

Property SourceId As %String(MAXLEN = 80) [ Required ];
Property ReceivedAt As %TimeStamp [ Required ];
Property SourceChannel As %String(MAXLEN = 20);
Property Payload As %String(MAXLEN = 5000) [ Required ];

Index SourceIdIdx On SourceId [ Unique ];

Storage Default
{
<Data name="POSEventDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SourceId</Value>
</Value>
<Value name="3">
<Value>ReceivedAt</Value>
</Value>
<Value name="4">
<Value>SourceChannel</Value>
</Value>
<Value name="5">
<Value>Payload</Value>
</Value>
</Data>
<DataLocation>^Bronze.POSEventD</DataLocation>
<DefaultData>POSEventDefaultData</DefaultData>
<IdLocation>^Bronze.POSEventD</IdLocation>
<IndexLocation>^Bronze.POSEventI</IndexLocation>
<StreamLocation>^Bronze.POSEventS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
