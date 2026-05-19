Class Ops.AuditLog Extends %Persistent
{

Property EventId As %String(MAXLEN = 80) [ Required ];
Property EntityName As %String(MAXLEN = 100) [ Required ];
Property EntityId As %String(MAXLEN = 80) [ Required ];
Property ActionType As %String(MAXLEN = 50) [ Required ];
Property BeforeState As %String(MAXLEN = 5000);
Property AfterState As %String(MAXLEN = 5000);
Property CreatedAt As %TimeStamp;
Property CreatedBy As %String(MAXLEN = 100);

Index EventIdIdx On EventId [ Unique ];

Storage Default
{
<Data name="AuditLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EventId</Value>
</Value>
<Value name="3">
<Value>EntityName</Value>
</Value>
<Value name="4">
<Value>EntityId</Value>
</Value>
<Value name="5">
<Value>ActionType</Value>
</Value>
<Value name="6">
<Value>BeforeState</Value>
</Value>
<Value name="7">
<Value>AfterState</Value>
</Value>
<Value name="8">
<Value>CreatedAt</Value>
</Value>
<Value name="9">
<Value>CreatedBy</Value>
</Value>
</Data>
<DataLocation>^Ops.AuditLogD</DataLocation>
<DefaultData>AuditLogDefaultData</DefaultData>
<IdLocation>^Ops.AuditLogD</IdLocation>
<IndexLocation>^Ops.AuditLogI</IndexLocation>
<StreamLocation>^Ops.AuditLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
