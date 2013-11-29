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
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Dynamic;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;
using LocalDBProvider.Properties;
using Microsoft.iX.AggregationService.Configuration;
using Microsoft.iX.AggregationService.Entities;
using Microsoft.iX.AggregationService.Interfaces;
using Microsoft.iX.AggregationService.Providers;
using Microsoft.iX.AggregationService.Providers.Interfaces;

namespace LocalDBProvider
{
	/// <summary>
	/// A Script Explorer Search Provider that queries an MS SQL Database
	/// </summary>
	[CLSCompliant(false)]
	public class SearchProvider : BaseSearchProvider, ISaveProvider
	{
		/// <summary>
		/// The connectionString settings
		/// </summary>
		private ConnectionStringSettings connectionStringSettings;

		/// <summary>
		/// Initializes a new instance of the DatabaseSearchProvider class.
		/// The class is created by the Script Explorer framework when a Search or Save operation
		/// is performed, either by a client GUI or through a REST URL access. A fresh object
		/// is created for each operation.
		/// </summary>
		/// <param name="name">The Name of the search provider.</param>
		/// <param name="configuration">The configuration from app/web.config<see cref="IConfiguration"/>.</param>
		/// <param name="host">The host<see cref="IHost"/>.</param>
		/// <param name="logger">The logger.</param>
        /// <param name="settings">The settings.</param>
        public SearchProvider(string name, RepositoryElement configurationElement, IHost host, ILogger logger, ISettingsManager settings)
			: base(name, configurationElement, host, logger, settings)
		{
			this.connectionStringSettings = GetConnectionStringSettings(ConfigurationElement.Attributes["connectionString"]);
		}

		/// <summary>
		/// Gets the prefix of the moniker that uniquely specifies this provider.
		/// Choose a string that characterizes the provider and will not be easily duplicated on the same host system.
		/// IMPORTANT NOTE: The string must be pre-fixed to all moniker strings and is used to identify calls that
		/// would be routed to this provider. Hence notice that all script locators begin with this string followed by :
		/// </summary>
		public override string Moniker
		{
			get { return ScriptIdentityKey.ProviderIdentifier; }
		}

		/// <summary>
		/// Queries the local MS SQL Database
		/// </summary>
		/// <param name="searchCriteria">The search criteria.</param>
		/// <returns>
		/// Returns an IEnumerable of Scripts.
		/// </returns>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1031:DoNotCatchGeneralExceptionTypes")]
        public override IEnumerable Search(string searchCriteria)
		{
            var result = new List<Script>();

            try
            {
                var sanitizedSearchCriteria = SanitizeSearchCriteria(searchCriteria);

                var tuple = ParseSearchCriteria(sanitizedSearchCriteria);

                using (var connection = new SqlConnection(this.connectionStringSettings.ConnectionString))
                {
                    var searchTerm = tuple.Item1;

                    if (searchTerm.Contains(" AND "))
                    {
                        var andParts = tuple.Item1.Replace(" AND ", "&").Split('&');

                        var aggregatedScripts = new List<List<Script>>();

                        for (int i = 0; i < 2; i++)
                        {
                            var aux = FetchScriptsFromDb(connection, andParts[i], tuple.Item2);
                            aggregatedScripts.Add(aux);
                        }

                        var scripts = aggregatedScripts[0].Join(aggregatedScripts[1],
                           a => a.ScriptId,
                           b => b.ScriptId,
                           (a, b) => a).ToList();
                        return scripts;
                    }

                    if (searchTerm.Contains(" OR "))
                    {
                        var orParts = tuple.Item1.Replace(" OR ", "|").Split('|');

                        var aggregatedScripts = new List<List<Script>>();

                        for (int i = 0; i < 2; i++)
                        {
                            var aux = FetchScriptsFromDb(connection, orParts[i], tuple.Item2);
                            aggregatedScripts.Add(aux);
                        }

                        var scripts = aggregatedScripts[0].Union(aggregatedScripts[1]).Distinct();
                        return scripts;
                    }

                    // not an OR nor an AND
                    return FetchScriptsFromDb(connection, searchTerm, tuple.Item2);
                }
            }
            catch (Exception ex)
            {
                if (this.Logger != null)
                {
                    this.Logger.Log(ex.Message, System.Diagnostics.TraceLevel.Error, 400); 
                }
            }

            return result;
		}

        private List<Script> FetchScriptsFromDb(SqlConnection connection, string searchTerm, string focusGroups)
        {
            var result = new List<Script>();
            using (var command = new SqlCommand())
            {
                command.Connection = connection;
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandText = "GetScripts";
                command.Parameters.Add(new SqlParameter("SearchTerm", searchTerm));
                command.Parameters.Add(new SqlParameter("FocusGroups", focusGroups));

                if (connection.State != ConnectionState.Open)
                {
                    connection.Open();
                }

                var reader = command.ExecuteReader();

                while (reader.Read())
                {
                    result.Add(
                            new Script()
                            {
                                Title = reader["Title"].ToString(),
                                Summary = reader["Summary"].ToString(),
                                Attachment = reader["Attachment"].ToString(),
                                Name = reader["Name"].ToString(),
                                ScriptId = Guid.Parse(reader["ScriptId"].ToString()),
                                ScriptLocator = this.CreateScriptLocator(this.connectionStringSettings.Name, reader["ScriptId"].ToString()),
                                Source = this.DisplayName,
                                Locale = reader["Locale"].ToString(),
                                ContentType = Microsoft.iX.AggregationService.Entities.Constants.Entity
                            });
                }
                reader.Close();
            }

            return result;
        }

		public override object GetDetails(string moniker)
		{
			if(string.IsNullOrWhiteSpace(moniker))
			{
				throw new ArgumentNullException("moniker");
			}

			var monikerData = new ScriptIdentityKey(moniker);
			var settings = this.GetConnectionStringSettings(monikerData.ConnectionString);

			if(settings != null)
			{
				var connString = settings.ConnectionString;
				var details = new Script();

				using(var connection = new SqlConnection(connString))
				{
					connection.Open();

					using(var command = new SqlCommand())
					{
						command.Connection = connection;
						command.CommandType = System.Data.CommandType.StoredProcedure;
						command.CommandText = "GetDetails";

						command.Parameters.Add(new SqlParameter("Id", monikerData.ScriptId));

						var reader = command.ExecuteReader(System.Data.CommandBehavior.CloseConnection);

						if(reader.Read())
						{
							details.Author = reader["Author"].ToString();
							details.Source = GetDBName(connString);
							details.Description = reader["Description"].ToString();
							details.Organization = reader["Organization"].ToString();
							details.PublishedDate = DateTime.Parse(reader["PublishedDate"].ToString(), CultureInfo.CurrentCulture);
							details.Raters = int.Parse(reader["Raters"].ToString(), CultureInfo.CurrentCulture);
							details.Rating = double.Parse(reader["Rating"].ToString(), CultureInfo.CurrentCulture);
							details.ScriptCode = reader["ScriptCode"].ToString();
							details.SupportedPlatform = reader["SupportedPlatform"].ToString();
							details.Tags = reader["Tags"].ToString();
							details.Disclaimer = Properties.Resources.DatabaseDisclaimer;
							details.Link = reader["Id"].ToString();
                            details.ContentType = Microsoft.iX.AggregationService.Entities.Constants.Entity;
						}

						return details;
					}
				}
			}

			return null;
		}

		/// <summary>
		/// Gets the status.
		/// </summary>
		/// <returns></returns>
		public override ProviderStatus GetStatus()
		{
			var status = new ProviderStatus();

			if(this.ServiceIsAvailable())
			{
				status.Code = 200;
				status.Message = string.Format(CultureInfo.CurrentCulture, Resources.OKMessage);

				this.Logger.Log(string.Format(CultureInfo.CurrentCulture, Resources.LogInfoMessage, this.Name, status.Message), System.Diagnostics.TraceLevel.Info, 0);
			}
			else
			{
				status.Code = 400;
				status.Message = string.Format(CultureInfo.CurrentCulture, Resources.FailMessage);

				this.Logger.Log(string.Format(CultureInfo.CurrentCulture, Resources.LogErrorMessage, this.Name, status.Message), System.Diagnostics.TraceLevel.Error, 400);
			}

			return status;
		}

		/// <summary>
		///  Verifies if the provider can save
		/// </summary>
		/// <returns>Returns true if it can save otherwise false.</returns>
		public bool CanSave()
		{
			return this.ServiceIsAvailable();
		}

		/// <summary>
		/// Saves the <see cref="ScriptDetails"/> to the database.
		/// </summary>
		/// <param name="entityToSave">The entity to save.</param>
		/// <param name="context">The <see cref="ExpandoObject"/> context.</param>
		public string Save(object entity, ExpandoObject context = null)
		{
			if(entity == null)
			{
				throw new ArgumentNullException("entity");
			}

			var script = entity as Script;

			using(var connection = new SqlConnection(this.connectionStringSettings.ConnectionString))
			{
				using(var command = new SqlCommand())
				{
					command.Connection = connection;
					command.CommandType = System.Data.CommandType.StoredProcedure;
					command.CommandText = "AddScripts";

					var name = string.IsNullOrWhiteSpace(script.Source) ? "Script Name" : script.Source;

					command.Parameters.Add(new SqlParameter("Name", name ?? string.Empty));
					command.Parameters.Add(new SqlParameter("Summary", script.Summary ?? string.Empty));
					command.Parameters.Add(new SqlParameter("Author", script.Author ?? string.Empty));
					command.Parameters.Add(new SqlParameter("PublishedDate", script.PublishedDate.GetValueOrDefault(DateTime.Now)));
					command.Parameters.Add(new SqlParameter("Title", script.Title ?? string.Empty));
					command.Parameters.Add(new SqlParameter("ScriptLocator", script.Link ?? string.Empty));
					command.Parameters.Add(new SqlParameter("Rating", script.Rating));
					command.Parameters.Add(new SqlParameter("Organization", script.Organization ?? string.Empty));
					command.Parameters.Add(new SqlParameter("Tags", script.Tags ?? string.Empty));
					command.Parameters.Add(new SqlParameter("SupportedPlatform", script.SupportedPlatform ?? string.Empty));
					command.Parameters.Add(new SqlParameter("ScriptCode", script.ScriptCode ?? string.Empty));
					command.Parameters.Add(new SqlParameter("ScriptId", Guid.NewGuid()));
					command.Parameters.Add(new SqlParameter("Locale", "en-us"));
					command.Parameters.Add(new SqlParameter("Description", script.Description ?? string.Empty));
					command.Parameters.Add(new SqlParameter("Attachment", null));
					command.Parameters.Add(new SqlParameter("Raters", script.Raters));

					connection.Open();

					command.ExecuteNonQuery();
				}
			}

            return string.Empty;
		}

		private static string SanitizeSearchCriteria(string searchCriteria)
		{
			var sanitizePattern = @"[^0-9a-zA-Z \(\)-]";

			return Regex.Replace(searchCriteria, sanitizePattern, string.Empty);
		}

		private static Tuple<string, string> ParseSearchCriteria(string searchCriteria)
		{
			var contentRegex = new Regex(@"\(.*\)", RegexOptions.CultureInvariant | RegexOptions.Compiled);
			var match = contentRegex.Match(searchCriteria);

			if(!match.Success)
			{
				return new Tuple<string, string>(searchCriteria.Trim(), string.Empty);
			}
			else
			{
				var parenthesis = searchCriteria.IndexOf("(", StringComparison.OrdinalIgnoreCase);
				var searchTerm = searchCriteria.Substring(0, parenthesis).Trim();
				var upper = searchCriteria.LastIndexOf(")", StringComparison.OrdinalIgnoreCase) - searchTerm.Length;
				var parts = searchCriteria.Substring(parenthesis + 1, upper - 2);
				var focusGroups = parts.Replace(" OR ", ",").Trim();

				return new Tuple<string, string>(searchTerm, focusGroups);
			}
		}

		private static string GetDBName(string connectionString)
		{
			return new SqlConnectionStringBuilder(connectionString).InitialCatalog;
		}

		private bool ServiceIsAvailable()
		{
			try
			{
				using(var connection = new SqlConnection(this.connectionStringSettings.ConnectionString))
				{
					connection.Open();

					return connection.State == ConnectionState.Open;
				}
			}
			catch 
			{
				return false;
			}
		}

		private string CreateScriptLocator(string connectionString, string scriptId)
		{
			var scriptKey = new ScriptIdentityKey(connectionString, Guid.Parse(scriptId), this.Name, this.Host.GetHostname());

			return scriptKey.ScriptLocator();
		}

		private ConnectionStringSettings GetConnectionStringSettings(string connectionStringName)
		{
			if(string.IsNullOrEmpty(connectionStringName))
			{
				throw new InvalidOperationException(Resources.EmptyConnectionString);
			}

			var section = this.ConfigurationElement.CurrentConfiguration.GetSection("connectionStrings") as ConnectionStringsSection;

			if(section == null)
			{
				throw new InvalidOperationException(Resources.ConnectionStringsSectionMissing);
			}

			var settings = section.ConnectionStrings[connectionStringName];

			if(settings == null)
			{
				throw new ArgumentNullException(string.Format(CultureInfo.CurrentCulture, Resources.InvalidConnectionString, connectionStringName));
			}

			return settings;
		}

        public override object Clone()
        {
            var cloned = new SearchProvider(this.Name, this.ConfigurationElement, this.Host, this.Logger, this.Settings);
            return cloned;
        }


        public string GetSaveLocation()
        {
            var builder = new SqlConnectionStringBuilder(this.connectionStringSettings.ConnectionString);
            return builder.InitialCatalog;
        }
    }
}