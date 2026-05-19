Class Config.Rules Extends %Persistent
{

Property RuleCode As %String(MAXLEN = 50) [ Required ];
Property RuleName As %String(MAXLEN = 100);
Property Severity As %String(MAXLEN = 20);
Property ThresholdValue As %Numeric;
Property WindowHours As %Integer;
Property IsActive As %Boolean [ InitialExpression = 1 ];
Property Description As %String(MAXLEN = 500);

Index RuleCodeIdx On RuleCode [ Unique ];

Storage Default
{
<Data name="RulesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RuleCode</Value>
</Value>
<Value name="3">
<Value>RuleName</Value>
</Value>
<Value name="4">
<Value>Severity</Value>
</Value>
<Value name="5">
<Value>ThresholdValue</Value>
</Value>
<Value name="6">
<Value>WindowHours</Value>
</Value>
<Value name="7">
<Value>IsActive</Value>
</Value>
<Value name="8">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^Config.RulesD</DataLocation>
<DefaultData>RulesDefaultData</DefaultData>
<IdLocation>^Config.RulesD</IdLocation>
<IndexLocation>^Config.RulesI</IndexLocation>
<StreamLocation>^Config.RulesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
