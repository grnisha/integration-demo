param logicAppId string
param workflow string

var url = listCallbackURL('${logicAppId}/hostruntime/runtime/webhooks/workflow/api/management/workflows/${workflow}/triggers/manual', '2022-03-01')
var apiVersion = url.queries['api-version']

output url object = {
  basePath: url.basePath
  queries: '?api-version=${uriComponent(apiVersion)}&amp;sv=${uriComponent(url.queries.sv)}&amp;sp=${uriComponent(url.queries.sp)}&amp;sig=${uriComponent(url.queries.sig)}'
}
