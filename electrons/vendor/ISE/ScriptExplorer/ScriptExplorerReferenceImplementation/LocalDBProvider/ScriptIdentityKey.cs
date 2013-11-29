// ===================================================================================
// Microsoft Information Experience Team (Server and Cloud Division)
// ==================================================================================
// Copyright (c) Microsoft Corporation.  All rights reserved.
// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY
// OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT
// LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
// FITNESS FOR A PARTICULAR PURPOSE.
// ===================================================================================
// The example companies, organizations, products, domain names,
// e-mail addresses, logos, people, places, and events depicted
// herein are fictitious.  No association with any real company,
// organization, product, domain name, email address, logo, person,
// places, or events is intended or should be inferred.
// ===================================================================================

using System;
using System.Globalization;

namespace LocalDBProvider
{
    /// <summary>
    /// This class specifies what makes a script unique (across all data sources)
    /// 
    /// In case of a script housed in a database, this provider has been designed with the
    /// thought that a script in a database is entirely specified by -
    ///     * ID of the script, which makes it unique in the database
    ///     * Connection string of the DB in which it is housed
    ///     * The host provider that provided the search result (specific to remote providers)
    ///     * Provider Name (specific to remote providers)
    /// 
    /// Other provider authors can identify similar fields that uniquely describe their script assets,
    /// but we highly recommend maintaining the last two fields (provider name and host provider) for
    /// most cases to maintain remote operation.
    /// </summary>
    public class ScriptIdentityKey
    {
        public const string ProviderIdentifier = "database";

        /// <summary>
        /// Gets the connection string.
        /// </summary>
        public string ConnectionString { get; private set; }

        /// <summary>
        /// Gets the script id.
        /// </summary>
        public Guid ScriptId { get; private set; }

        /// <summary>
        /// Gets the name of the provider.
        /// </summary>
        /// <value>
        /// The name of the provider.
        /// </value>
        public string ProviderName { get; private set; }

        /// <summary>
        /// Gets the name of the machine.
        /// </summary>
        /// <value>
        /// The name of the machine.
        /// </value>
        public string MachineName { get; private set; }


		/// <summary>
		/// Initializes a new ScriptIdentityKey object with field values provided in parameters
		/// </summary>
		/// <param name="connectionString">Connection string</param>
		/// <param name="scriptId">Script id</param>
		/// <param name="providerName">Provider name (essential for correct remote operation)</param>
		/// <param name="machineName">Machine name (essential for correct remote operation)</param>
        public ScriptIdentityKey(string connectionString, Guid scriptId, string providerName, string machineName)
        {
            this.ConnectionString = connectionString;
            this.ScriptId = scriptId;
            this.ProviderName = providerName;
            this.MachineName = machineName;
        }

		/// <summary>
		/// Parses a locator string to get the required fields
		/// </summary>
		/// <param name="locator">The script locator string set in the Search(..) method of <seealso cref="SearchProvider"/>.</param>
        public ScriptIdentityKey(string locator)
        {
			if(string.IsNullOrEmpty(locator))
            {
                throw new ArgumentNullException("locator");
            }

            try
            {
                var sanitizedMoniker = locator.Replace("'", string.Empty);
                var position = sanitizedMoniker.IndexOf(':') + 1;
                var length = sanitizedMoniker.Length - position;
                var parameters = sanitizedMoniker.Substring(position, length);

                var parts = parameters.Split(new[] { ':' }, StringSplitOptions.RemoveEmptyEntries);

                this.ConnectionString = parts[0];
                this.ScriptId = Guid.Parse(parts[1]);
            }
            catch
            {
                throw new InvalidOperationException(
					string.Format(CultureInfo.CurrentCulture, Properties.Resources.InvalidMonikerFormat, "database:connectionString:id:providerName:hostName"));
            }
        }

        /// <summary>
        /// Composes the locator string by combining the required fields. Note that the string begins with the provider
        /// identifier so that the calls are correctly routed to this provider.
        /// </summary>
        /// <returns>A formatted script locator string ready to be attached to a search result.</returns>
        public string ScriptLocator()
        {
            return string.Format(
				CultureInfo.CurrentCulture, 
				"{0}:{1}:{2}:{3}:{4}",
                ScriptIdentityKey.ProviderIdentifier,
                this.ConnectionString,
                this.ScriptId.ToString(),
                this.ProviderName,
                this.MachineName);
        }
    }
}
