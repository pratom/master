#http://blogs.clariusconsulting.net/kzu/how-to-use-c-typeof-in-powershell/
<#
Add-Type @'

using System;
using System.Globalization;
using System.Management.Automation;
using System.Configuration;

//namespace Clarius.PowerShell
namespace pratom 
{
    [Cmdlet(VerbsCommon.Get, "Type")]
    public class GetTypeCommand : Cmdlet
    {
        private string typeName;

        [Parameter(Mandatory=true, Position=0, HelpMessageResourceId="Parameter_TypeName")]
        public string TypeName
        {
            get { return typeName; }
            set { typeName = value; }
        }

        protected override void ProcessRecord()
        {
            string name = typeName;
            if (name.StartsWith("[")) name = name.Substring(1);
            if (name.EndsWith("]")) name = name.Substring(0, name.Length - 1);

            WriteObject(new System.Configuration.TypeNameConverter().ConvertFrom(name, typeof(Type), CultureInfo.CurrentCulture, true));

            :(            The type or namespace name 'TypeNameConverter' does not exist in the namespace 'System.Configuration' (are you missing an assembly reference?)
        }
    }
}
'@
#>