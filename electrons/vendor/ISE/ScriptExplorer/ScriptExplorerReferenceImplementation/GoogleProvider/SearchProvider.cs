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
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Script.Serialization;
using GoogleProvider.Properties;
using Microsoft.iX.AggregationService.Configuration;
using Microsoft.iX.AggregationService.Entities;
using Microsoft.iX.AggregationService.Interfaces;
using Microsoft.iX.AggregationService.Providers;
using Microsoft.iX.AggregationService.Providers.Common;
using Microsoft.iX.AggregationService.Providers.Interfaces;

namespace GoogleProvider
{
    /// <summary>
    /// A Script Explorer Search Provider implementation for Google Search
    /// </summary>
    
    public class SearchProvider : BaseSearchProvider
    {
        private const string MaxResultsAttributeName = "maxResults";
        private const string ApiKeyAttributeName = "key";
        private const string CustomSearchIdAttributeName = "customSearchId";
        private const string CustomSearchReferenceAttributeName = "customSearchReference";

        private const string GoogleSearchUri = "https://www.googleapis.com/customsearch/v1?key={0}&num={1}&q={2}";

        public const int DefaultMaxResults = 10;

        private IWebRequestor webRequestor;

        /// <summary>
        /// Initializes a new instance of the SearchProvider class.
        /// The class is created by the Script Explorer framework when a Search is performed, 
        /// either by a client GUI or through a REST URL access. A fresh object
        /// is created for each operation.
        /// </summary>
        /// <param name="name">The Provider name</param>
        /// <param name="configurationElement">The configuration from app/web.config<</param>
        /// <param name="host">The configured host</param>
        /// <param name="logger">The configured logger</param>
        /// <param name="settings">The settings.</param>
        public SearchProvider(string name, RepositoryElement configurationElement, IHost host, ILogger logger, ISettingsManager settings)
            : this(name, configurationElement, host, logger, settings, new WebRequestor())
        {
        }

        /// <summary>
        /// Initializes a new instance of the SearchProvider class.
        /// The class is created by the Script Explorer framework when a Search is performed, 
        /// either by a client GUI or through a REST URL access. A fresh object
        /// is created for each operation.
        /// </summary>
        /// <param name="name">The Provider name</param>
        /// <param name="configurationElement">The configuration from app/web.config<</param>
        /// <param name="host">The configured host</param>
        /// <param name="logger">The configured logger</param>
        /// <param name="settings">The settings.</param>
        /// <param name="webRequestor">A web requestor implementation for making http requests</param>
        public SearchProvider(string name, RepositoryElement configurationElement, IHost host, ILogger logger, ISettingsManager settings, IWebRequestor webRequestor)
            : base(name, configurationElement, host, logger, settings)
        {
            Guard.NotNull(() => webRequestor, webRequestor);

            this.ApiKey = ConfigurationElement.Attributes[ApiKeyAttributeName];
            
            if(string.IsNullOrEmpty(this.ApiKey))
            {
                throw new ArgumentNullException(string.Format(CultureInfo.CurrentCulture, Resources.KeyMissing, name));
            }

            var maxResultsValue = ConfigurationElement.Attributes[MaxResultsAttributeName];
            int maxResults;

            if (int.TryParse(maxResultsValue, out maxResults))
            {
                if (maxResults > DefaultMaxResults)
                {
                    this.MaxResults = DefaultMaxResults;
                }
                else
                {
                    this.MaxResults = maxResults;
                }
            }
            else
            {
                this.MaxResults = DefaultMaxResults;
            }

            this.CustomSearchId = ConfigurationElement.Attributes[CustomSearchIdAttributeName];
            this.CustomSearchReference = ConfigurationElement.Attributes[CustomSearchReferenceAttributeName];

            if (string.IsNullOrEmpty(this.CustomSearchId) && string.IsNullOrEmpty(this.CustomSearchReference))
            {
                throw new ArgumentNullException(string.Format(CultureInfo.CurrentCulture, Resources.CustomSearchMissing, name));
            }

            this.webRequestor = webRequestor;
        }

        /// <summary>
        /// Gets the moniker.
        /// </summary>
        public override string Moniker
        {
            get { return "GOOGLE"; }
        }

        /// <summary>
        /// An Api key for using the Google Search Api
        /// </summary>
        public string ApiKey
        {
            get;
            private set;
        }

        /// <summary>
        /// The maximum number of expected results in the response. It must be a value between 1 and 10
        /// </summary>
        public int MaxResults
        {
            get;
            private set;
        }

        /// <summary>
        /// A valid identifier for an existing custom search stored in Google
        /// </summary>
        public string CustomSearchId
        {
            get;
            private set;
        }

        /// <summary>
        /// An Url pointing to an existing linked custom search.
        /// </summary>
        public string CustomSearchReference
        {
            get;
            private set;
        }

        /// <summary>
        /// Creates a new instance of the SearchProvider copying all the existing properties values
        /// </summary>
        /// <returns>A new instance of the SearchProvider</returns>
        public override object Clone()
        {
            return new SearchProvider(this.Name, this.ConfigurationElement, this.Host, this.Logger, this.Settings, this.webRequestor);
        }

        /// <summary>
        /// Gets the details associated to the record with the given moniker
        /// </summary>
        /// <param name="moniker">A moniker that identifies a single record</param>
        /// <returns>An Script object referencing the record details</returns>
        public override object GetDetails(string moniker)
        {
            Guard.NotNullOrWhiteSpace(() => moniker, moniker);

            if (!moniker.Contains(":"))
                throw new InvalidOperationException(Resources.InvalidMoniker);

            var sanitizedMoniker = moniker.Replace("'", string.Empty);

            var position = sanitizedMoniker.IndexOf(':') + 1;
            var length = sanitizedMoniker.Length - position;
            var id = sanitizedMoniker.Substring(position, length);
            var parts = id.Split(new[] { ':' }, StringSplitOptions.RemoveEmptyEntries);
            var uri = "http:" + parts[1];
            
            var detail = new Script();
            detail.Link = uri;
            detail.ContentType = Microsoft.iX.AggregationService.Entities.Constants.Html;
            
            return detail;
        }

        /// <summary>
        /// Returns a ProviderStatus instance with details of the Google Search API availability
        /// </summary>
        /// <returns></returns>
        public override ProviderStatus GetStatus()
        {
            if (!WebClientHelper.IsConnectionAvailable())
                return new ProviderStatus() { Code = 400, Message = string.Format(CultureInfo.CurrentCulture, Resources.FailMessage) };

            var requestString = FormatSearchUri(string.Empty, 1);

            var webGet = this.webRequestor.WebGet(new Uri(requestString));
            try
            {
                var response = webGet.GetResponse();
                
                response.Close();

                this.Logger.Log(string.Format(CultureInfo.CurrentCulture, Resources.LogInfoMessage, this.Name, Resources.OKMessage), TraceLevel.Info, 0);
                    
                return new ProviderStatus
                {
                    Code = 200,
                    Message = Resources.OKMessage
                };
                
            }
            catch(Exception)
            {
                this.Logger.Log(string.Format(CultureInfo.CurrentCulture, Resources.LogErrorMessage, this.Name, Resources.FailMessage), TraceLevel.Error, 400);

                return new ProviderStatus
                {
                    Code = 400,
                    Message = Resources.FailMessage
                };
            }
        }

        /// <summary>
        /// Performs a query in Google Search using the given criteria
        /// </summary>
        /// <param name="searchCriteria">Search criteria to be used by the search definition</param>
        /// <returns>A list of Script instances representing the results of the search</returns>
        public override IEnumerable Search(string searchCriteria)
        {
            if (string.IsNullOrEmpty(searchCriteria))
                return Enumerable.Empty<object>();

            var requestString = FormatSearchUri(searchCriteria, this.MaxResults);

            var webGet = this.webRequestor.WebGet(new Uri(requestString));
            try
            {
                var response = webGet.GetResponse();
                
                using (var stream = response.GetResponseStream()) 
                {
                    var streamReader = new StreamReader(stream);
                        
                    var content = streamReader.ReadToEnd();

                    if(content.Length > 0) 
                    {
                        var serializer = new JavaScriptSerializer();
                        var deserializedContent = serializer.Deserialize(content, typeof(object));

                        return ParseResponse((IDictionary<string, object>)deserializedContent);
                    }
                        
                }
                response.Close();
            }
            catch (Exception e)
            {
                this.Logger.Log(string.Format(CultureInfo.CurrentCulture, Resources.LogErrorMessage, this.Name, "Google Search ex-" + e.Message), TraceLevel.Error, 1994);
            }

            return null;
        }

        /// <summary>
        /// Returns the URL for performing a search in Google
        /// </summary>
        /// <param name="searchCriteria">Search criteria</param>
        /// <param name="maxResults">Number of expected results</param>
        /// <returns>A valid URL</returns>
        private string FormatSearchUri(string searchCriteria, int maxResults)
        {
            var searchText = searchCriteria;
            if (Regex.Match(searchText, @"\sOR\s").Success)
            {
                searchText = string.Concat("(", searchText, ")");
            }

            var requestString = string.Format(CultureInfo.CurrentCulture, GoogleSearchUri, this.ApiKey, maxResults, searchText);

            if (!string.IsNullOrEmpty(this.CustomSearchId))
            {
                requestString += "&cx=" + this.CustomSearchId;
            }
            else if (!string.IsNullOrEmpty(this.CustomSearchReference))
            {
                requestString += "&cref=" + this.CustomSearchReference;
            }

            return requestString;
        }

        /// <summary>
        /// Converts the result returned by Google into an Script instance
        /// </summary>
        /// <param name="response">Google's API response</param>
        /// <returns>A list of Script instances mapped from the response</returns>
        private IEnumerable ParseResponse(IDictionary<string, object> response)
        {
            var parsedItems = new List<Script>();
            var hostName = Host.GetHostname();
            if (response.ContainsKey("items"))
            {
                var items = (object[])response["items"];
                foreach (IDictionary<string, object> item in items)
                {
                    if((string)item["kind"] == "customsearch#result")
                    {
                        parsedItems.Add(new Script
                        {
                            Name = (string)item["title"],
                            Title = (string)item["title"],
                            Summary = (string)item["snippet"],
                            Description = (string)item["snippet"],
                            ScriptLocator = string.Format(CultureInfo.CurrentCulture, "{0}:{1}:{2}:{3}", this.Moniker, HttpUtility.UrlEncode((string)item["link"]), HttpUtility.UrlEncode((string)item["title"]), hostName),
                            ContentType = Microsoft.iX.AggregationService.Entities.Constants.Html,
                            Version = (string)item["cacheId"],
                            Source = this.DisplayName
                        });
                    }
                }
            }

            return parsedItems;
        }
    }
}
