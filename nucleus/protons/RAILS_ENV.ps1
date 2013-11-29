function RAILS_ENV.DEVELOPMENT
{
    [cmdletbinding()] Param () 
    return "development"
}


function RAILS_ENV.PRODUCTION
{
    [cmdletbinding()] Param () 
    return "production"
}


function RAILS_ENV.TESTING
{
    [cmdletbinding()] Param () 
    return "testing"
}


function get_rails_env_at_startup
{
   [cmdletbinding()] Param () 
   return RAILS_ENV.DEVELOPMENT   #for right now, hardcoded.....
}


$SCRIPT:rails_env=get_rails_env_at_startup
function RAILS_ENV
{
    [cmdletbinding()] Param () 
    return $SCRIPT:rails_env
}
