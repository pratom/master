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
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;

namespace GoogleProvider
{
    /// <summary>
    /// A service for abstracting http calls
    /// </summary>
    public interface IWebRequestor
    {
        /// <summary>
        /// Returns a WebRequest instance for performing an http web get
        /// </summary>
        /// <param name="uri">The URL to be used in the Web Get</param>
        /// <returns>A valid instance WebRequest</returns>
        WebRequest WebGet(Uri uri);
    }
}
