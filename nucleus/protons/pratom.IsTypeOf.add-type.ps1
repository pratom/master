#http://blogs.clariusconsulting.net/kzu/how-to-use-c-typeof-in-powershell/
<#
Add-Type @'

using System;
using System.Globalization;
using System.Management.Automation;
using System.Configuration;

namespace pratom 
{
    [Cmdlet(VerbsCommon.Get, "IsTypeOf")]
    public class Get-IsTypeOfCommand : Cmdlet
    {
        private object _InputObject;

        [Parameter(Mandatory=true, Position=0, HelpMessageResourceId="InputObject")]
        public object InputObject
        {
            get { return _InputObject; }
            set { typeName = _InputObject; }
        }


        private object _ClassToTestAgainst;
        [Parameter(Mandatory=true, Position=0, HelpMessageResourceId="ClassToTestAgainst")]
        public object ClassToTestAgainst
        {
            get { return _ClassToTestAgainst; }
            set { _ClassToTestAgainst = value; }
        }


        protected override void ProcessRecord()
        {
            [bool] is_that_type = (InputObject is ClassToTestAgainst) ;

            WriteObject(is_that_type);
        }
    }
}
'@
#>