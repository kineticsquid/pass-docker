# Purpose

Our goal is to run the PASS project in a Kubernetes cluster running on infrastructure managed by the Eclipse Foundation. PASS is currently using a docker compose environment for running its test environment.

For creating the Kubernetes configuration for the PASS project we are using the [Digital Ocean service](https://www.digitalocean.com/) to create test clusters. This allows us to have full control over the environment while we determine how to configure each of the PASS components. Once this configuration is fully functional in a test cluster we will then migrate it to the Eclipe Foundation infrastructure.

### Prerequisites

1. [Install doctl](https://docs.digitalocean.com/reference/doctl/how-to/install/).
2. [Generate a token](https://cloud.digitalocean.com/account/api/tokens/new) with Digital Ocean.
3. Authenticate with Digital Ocean using the token: `doctl auth init`.
4. [Install kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) (this is the Kubernetes command line tool)

## Create Kubernetes cluster

Run these commands to create a new Kubernetes cluster in Digital Ocean and deploy the available containers:

```
doctl kubernetes cluster create pass-docker --auto-upgrade=true --node-pool "name=passnp;count=2;auto-scale=true;min-nodes=1;max-nodes=3;size=s-2vcpu-4gb" --region tor1

kubectl create secret docker-registry regcred --docker-server=https://ghcr.io --docker-username=grant-mcs --docker-password=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

kubectl apply -f passdata-persistentvolume.yaml
kubectl apply -f passdata-persistentvolumeclaim.yaml
kubectl apply -f assets-job.yaml

kubectl apply -f proxy-deployment.yaml
kubectl apply -f proxy-service.yaml 
kubectl apply -f static-html-deployment.yaml 
kubectl apply -f static-html-service.yaml 
kubectl apply -f ember-deployment.yaml
kubectl apply -f ember-service.yaml
kubectl apply -f sp-secrets.yaml
kubectl apply -f sp-deployment.yaml
kubectl apply -f sp-service.yaml

kubectl apply -f ldap-deployment.yaml
kubectl apply -f ldap-service.yaml
kubectl apply -f idp-secrets.yaml
kubectl apply -f idp-deployment.yaml
kubectl apply -f idp-service.yaml
kubectl apply -f elasticsearch-deployment.yaml
kubectl apply -f elasticsearch-service.yaml

kubectl apply -f activemq-deployment.yaml
kubectl apply -f activemq-service.yaml
kubectl apply -f schemaservice-deployment.yaml
kubectl apply -f schemaservice-service.yaml
kubectl apply -f fcrepo-deployment.yaml
kubectl apply -f fcrepo-service.yaml
kubectl apply -f authz-deployment.yaml

kubectl apply -f indexer-deployment.yaml
kubectl apply -f downloadservice-deployment.yaml
kubectl apply -f downloadservice-service.yaml
kubectl apply -f deposit-deployment.yaml
kubectl apply -f deposit-service.yaml
kubectl apply -f doiservice-deployment.yaml
kubectl apply -f doiservice-service.yaml

kubectl apply -f postgres-deployment.yaml
kubectl apply -f postgres-service.yaml
kubectl apply -f dspace-deployment.yaml
kubectl apply -f dspace-service.yaml
kubectl apply -f ftpserver-deployment.yaml
kubectl apply -f ftpserver-service.yaml

kubectl apply -f notification-deployment.yaml
kubectl apply -f notification-service.yaml
kubectl apply -f policyservice-deployment.yaml
kubectl apply -f policyservice-service.yaml

kubectl apply -f mail-claim2-persistentvolumeclaim.yaml
kubectl apply -f maildata-persistentvolumeclaim.yaml
kubectl apply -f mailstate-persistentvolumeclaim.yaml
kubectl apply -f mail-deployment.yaml
kubectl apply -f mail-service.yaml
```

## Running PASS

### Create a `pass.local` alias
Once the Kubernetes cluster has been created, you can monitor it by selecting it from the list in the [Digital Ocean Kubernetes console](https://cloud.digitalocean.com/kubernetes/clusters). From there you can find the `proxy` service and see its external IP address. Alternatively, from the command line you can run this command to find the external IP address:

```
kubectl get services
```

The external IP address of the `proxy` service should be added as an alias to the `pass.local` URL by adding a line like this to your local `/etc/hosts` file:

```
157.230.70.93   pass.local
```

### Launch the home page

In a web browser, enter the external IP address of the `proxy` service. You will likely be warned about a security risk because the certificate for the site is self-signed. Accept the risk, continue, and you should see the PASS home page.

## Known Problems

### elasticsearch startup error

On container startup there is an error trying to access the `/usr/share/elasticsearch/data/nodes` folder. When the elasticsearch deployment was using its own persistent volume this error was solved by changing the ownership of the mounted volume with this addition to the deployment configuration:

```
securityContext:
  fsGroup: 1000
```

When the persistent volume configuration was changed to share the same volume between assets, fcrepo, and elasticsearch the error returned. The `securityContext` was added to the configurations for each of these containers but the problem persists. Looking at the `/data` folder in the fcrepo container shows that everything is owned by `root`.

This is the full stack trace of the error:

```
[2022-08-27T20:17:37,052][WARN ][o.e.b.ElasticsearchUncaughtExceptionHandler] [] uncaught exception in thread [main]
org.elasticsearch.bootstrap.StartupException: java.lang.IllegalStateException: Failed to create node environment
    at org.elasticsearch.bootstrap.Elasticsearch.init(Elasticsearch.java:125) ~[elasticsearch-6.2.3.jar:6.2.3]
    at org.elasticsearch.bootstrap.Elasticsearch.execute(Elasticsearch.java:112) ~[elasticsearch-6.2.3.jar:6.2.3]
    at org.elasticsearch.cli.EnvironmentAwareCommand.execute(EnvironmentAwareCommand.java:86) ~[elasticsearch-6.2.3.jar:6.2.3]
    at org.elasticsearch.cli.Command.mainWithoutErrorHandling(Command.java:124) ~[elasticsearch-cli-6.2.3.jar:6.2.3]
    at org.elasticsearch.cli.Command.main(Command.java:90) ~[elasticsearch-cli-6.2.3.jar:6.2.3]
    at org.elasticsearch.bootstrap.Elasticsearch.main(Elasticsearch.java:92) ~[elasticsearch-6.2.3.jar:6.2.3]
    at org.elasticsearch.bootstrap.Elasticsearch.main(Elasticsearch.java:85) ~[elasticsearch-6.2.3.jar:6.2.3]
Caused by: java.lang.IllegalStateException: Failed to create node environment
    at org.elasticsearch.node.Node.<init>(Node.java:267) ~[elasticsearch-6.2.3.jar:6.2.3]
    at org.elasticsearch.node.Node.<init>(Node.java:246) ~[elasticsearch-6.2.3.jar:6.2.3]
    at org.elasticsearch.bootstrap.Bootstrap$5.<init>(Bootstrap.java:213) ~[elasticsearch-6.2.3.jar:6.2.3]
    at org.elasticsearch.bootstrap.Bootstrap.setup(Bootstrap.java:213) ~[elasticsearch-6.2.3.jar:6.2.3]
    at org.elasticsearch.bootstrap.Bootstrap.init(Bootstrap.java:323) ~[elasticsearch-6.2.3.jar:6.2.3]
    at org.elasticsearch.bootstrap.Elasticsearch.init(Elasticsearch.java:121) ~[elasticsearch-6.2.3.jar:6.2.3]
    ... 6 more
Caused by: java.nio.file.AccessDeniedException: /usr/share/elasticsearch/data/nodes
    at sun.nio.fs.UnixException.translateToIOException(UnixException.java:84) ~[?:?]
    at sun.nio.fs.UnixException.rethrowAsIOException(UnixException.java:102) ~[?:?]
    at sun.nio.fs.UnixException.rethrowAsIOException(UnixException.java:107) ~[?:?]
    at sun.nio.fs.UnixFileSystemProvider.createDirectory(UnixFileSystemProvider.java:384) ~[?:?]
    at java.nio.file.Files.createDirectory(Files.java:674) ~[?:1.8.0_161]
    at java.nio.file.Files.createAndCheckIsDirectory(Files.java:781) ~[?:1.8.0_161]
    at java.nio.file.Files.createDirectories(Files.java:767) ~[?:1.8.0_161]
    at org.elasticsearch.env.NodeEnvironment.<init>(NodeEnvironment.java:204) ~[elasticsearch-6.2.3.jar:6.2.3]
    at org.elasticsearch.node.Node.<init>(Node.java:264) ~[elasticsearch-6.2.3.jar:6.2.3]
    at org.elasticsearch.node.Node.<init>(Node.java:246) ~[elasticsearch-6.2.3.jar:6.2.3]
    at org.elasticsearch.bootstrap.Bootstrap$5.<init>(Bootstrap.java:213) ~[elasticsearch-6.2.3.jar:6.2.3]
    at org.elasticsearch.bootstrap.Bootstrap.setup(Bootstrap.java:213) ~[elasticsearch-6.2.3.jar:6.2.3]
    at org.elasticsearch.bootstrap.Bootstrap.init(Bootstrap.java:323) ~[elasticsearch-6.2.3.jar:6.2.3]
    at org.elasticsearch.bootstrap.Elasticsearch.init(Elasticsearch.java:121) ~[elasticsearch-6.2.3.jar:6.2.3]
    ... 6 more
```

### fcrepo user service error

When a user logs into PASS (e.g., `staff1`), a request is sent to the fcrepo container and this error occurs:

```
19:37:51.651 [           ajp-nio-8009-exec-1] WARN (PassRolesFilter) Could not apply roles filter
java.lang.RuntimeException: Error while looking up user by locatorIds[johnshopkins.edu:hopkinsid:FAKESWG, johnshopkins.edu:employeeid:906502, johnshopkins.edu:jhed:staff1]
    at org.dataconservancy.pass.authz.ShibAuthUserProvider.getUser(ShibAuthUserProvider.java:242)
    at org.dataconservancy.pass.authz.service.user.UserServlet.doGet(UserServlet.java:103)
    at javax.servlet.http.HttpServlet.service(HttpServlet.java:635)
    at javax.servlet.http.HttpServlet.service(HttpServlet.java:742)
    at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:231)
    at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)
    at org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:52)
    at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)
    at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)
    at org.dataconservancy.pass.authz.roles.PassRolesFilter.doFilter(PassRolesFilter.java:133)
    at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)
    at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)
    at org.dataconservancy.fcrepo.jsonld.request.JsonMergePatchFilter.doFilter(JsonMergePatchFilter.java:120)
    at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)
    at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)
    at org.dataconservancy.fcrepo.jsonld.request.UriProtocolFilter.doFilter(UriProtocolFilter.java:58)
    at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)
    at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)
    at org.dataconservancy.fcrepo.jsonld.deserialize.DeserializationFilter.doFilter(DeserializationFilter.java:104)
    at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)
    at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)
    at org.dataconservancy.fcrepo.jsonld.compact.CompactionFilter.doFilter(CompactionFilter.java:117)
    at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)
    at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)
    at org.apache.catalina.filters.RequestDumperFilter.doFilter(RequestDumperFilter.java:202)
    at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)
    at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)
    at org.apache.catalina.core.StandardWrapperValve.invoke(StandardWrapperValve.java:199)
    at org.apache.catalina.core.StandardContextValve.invoke(StandardContextValve.java:96)
    at org.apache.catalina.authenticator.AuthenticatorBase.invoke(AuthenticatorBase.java:493)
    at org.apache.catalina.core.StandardHostValve.invoke(StandardHostValve.java:137)
    at org.apache.catalina.valves.ErrorReportValve.invoke(ErrorReportValve.java:81)
    at org.apache.catalina.valves.AbstractAccessLogValve.invoke(AbstractAccessLogValve.java:660)
    at org.apache.catalina.core.StandardEngineValve.invoke(StandardEngineValve.java:87)
    at org.apache.catalina.connector.CoyoteAdapter.service(CoyoteAdapter.java:343)
    at org.apache.coyote.ajp.AjpProcessor.service(AjpProcessor.java:476)
    at org.apache.coyote.AbstractProcessorLight.process(AbstractProcessorLight.java:66)
    at org.apache.coyote.AbstractProtocol$ConnectionHandler.process(AbstractProtocol.java:808)
    at org.apache.tomcat.util.net.NioEndpoint$SocketProcessor.doRun(NioEndpoint.java:1498)
    at org.apache.tomcat.util.net.SocketProcessorBase.run(SocketProcessorBase.java:49)
    at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149)
    at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:624)
    at org.apache.tomcat.util.threads.TaskThread$WrappingRunnable.run(TaskThread.java:61)
    at java.lang.Thread.run(Thread.java:748)
Caused by: java.lang.RuntimeException: An error occurred while processing the query: (@type:User  AND locatorIds:"johnshopkins.edu:hopkinsid:FAKESWG")
    at org.dataconservancy.pass.client.elasticsearch.ElasticsearchPassClient.getIndexerResults(ElasticsearchPassClient.java:276)
    at org.dataconservancy.pass.client.elasticsearch.ElasticsearchPassClient.findByAttribute(ElasticsearchPassClient.java:124)
    at org.dataconservancy.pass.client.PassClientDefault.findByAttribute(PassClientDefault.java:132)
    at org.dataconservancy.pass.authz.ShibAuthUserProvider.findUserId(ShibAuthUserProvider.java:259)
    at org.dataconservancy.pass.authz.ShibAuthUserProvider.lambda$getUser$10(ShibAuthUserProvider.java:213)
    at org.dataconservancy.pass.authz.ExpiringLRUCache.lambda$getOrDo$0(ExpiringLRUCache.java:120)
    at java.util.concurrent.FutureTask.run(FutureTask.java:266)
    at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149)
    at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:624)
    ... 1 common frames omitted
Caused by: java.net.ConnectException: null
    at org.dataconservancy.pass.auth.filters.shaded.org.apache.http.nio.pool.RouteSpecificPool.timeout(RouteSpecificPool.java:168)
    at org.dataconservancy.pass.auth.filters.shaded.org.apache.http.nio.pool.AbstractNIOConnPool.requestTimeout(AbstractNIOConnPool.java:561)
    at org.dataconservancy.pass.auth.filters.shaded.org.apache.http.nio.pool.AbstractNIOConnPool$InternalSessionRequestCallback.timeout(AbstractNIOConnPool.java:822)
    at org.dataconservancy.pass.auth.filters.shaded.org.apache.http.impl.nio.reactor.SessionRequestImpl.timeout(SessionRequestImpl.java:183)
    at org.dataconservancy.pass.auth.filters.shaded.org.apache.http.impl.nio.reactor.DefaultConnectingIOReactor.processTimeouts(DefaultConnectingIOReactor.java:210)
    at org.dataconservancy.pass.auth.filters.shaded.org.apache.http.impl.nio.reactor.DefaultConnectingIOReactor.processEvents(DefaultConnectingIOReactor.java:155)
    at org.dataconservancy.pass.auth.filters.shaded.org.apache.http.impl.nio.reactor.AbstractMultiworkerIOReactor.execute(AbstractMultiworkerIOReactor.java:348)
    at org.dataconservancy.pass.auth.filters.shaded.org.apache.http.impl.nio.conn.PoolingNHttpClientConnectionManager.execute(PoolingNHttpClientConnectionManager.java:192)
    at org.dataconservancy.pass.auth.filters.shaded.org.apache.http.impl.nio.client.CloseableHttpAsyncClientBase$1.run(CloseableHttpAsyncClientBase.java:64)
    ... 1 common frames omitted
[27/Aug/2022:19:37:51 +0000] ajp-nio-8009-exec-1 10.244.0.34 - staff1@johnshopkins.edu 500 status, 1484 ms, 1129 bytes; "GET /pass-user-service/whoami HTTP/1.1" Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0) Gecko/20100101 Firefox/102.0
```
