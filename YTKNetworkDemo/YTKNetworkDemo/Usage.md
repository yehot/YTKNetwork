
https://github.com/yuantiku/YTKNetwork

1、YTKNetwork 是猿题库 iOS 研发团队基于 AFNetworking 封装的 iOS 网络库，其实现了一套 High Level 的 API，提供了更高层次的网络访问抽象。

    ·只有 BaseRequest.h 直接依赖于 AFNetworking 的 AFDownloadRequestOperation.h

    YTKNetworkAgent.h 依赖于 AFNetworking.h 和 AFDownloadRequestOperation.h


2、相比 AFNetworking，YTKNetwork 提供了以下更高级的功能：
    支持按时间缓存网络请求内容；
    支持按版本号缓存网络请求内容；
    支持统一设置服务器和 CDN 的地址；
    支持检查返回 JSON 内容的合法性；
    支持文件的断点续传；
    [支持 block 和 delegate 两种模式的回调方式]
    支持批量的网络请求发送，并统一设置它们的回调（实现在YTKBatchRequest类中）
    `支持方便地设置有相互依赖的网络请求的发送`，例如：发送请求A，根据请求A的结果，选择性的发送请求B和C，再根据B和C的结果，选择性的发送请求D。（实现在YTKChainRequest类中）
    支持网络请求 URL 的 filter，可以统一为网络请求加上一些参数，或者修改一些路径。
    `定义了一套插件机制，可以很方便地为 YTKNetwork 增加功能。猿题库官方现在提供了一个插件，可以在某些网络请求发起时，在界面上显示"正在加载"的 HUD。`

3、YTKNetwork 适合稍微复杂一些的项目，不适合个人的小项目。

    如果你的项目中需要缓存网络请求、管理多个网络请求之间的依赖、希望检查服务器返回的 JSON 是否合法，那么 YTKNetwork 能给你带来很大的帮助。
    如果你缓存的网络请求内容需要依赖特定版本号过期，那么 YTKNetwork 就能发挥出它最大的优势。

4、YTKNetwork 的基本的思想是`把每一个网络请求封装成对象`。

所以使用 YTKNetwork，你的`每一个请求都需要继承YTKRequest类`，通过覆盖父类的一些方法来构造指定的网络请求。

    把每一个网络请求封装成对象其实是使用了设计模式中的 Command 模式，它有以下好处：

    `将网络请求与具体的第三方库依赖隔离，方便以后更换底层的网络库`。实际上 YTKNetwork 最初是基于 ASIHttpRequest 的，我们只花了两天，就很轻松地切换到了 AFNetworking。
    `方便在基类中处理公共逻辑`，例如猿题库的数据版本号信息就统一在基类中处理。
    方便在基类中处理缓存逻辑，以及其它一些公共逻辑。
    方便做对象的持久化。

    当然，如果说它有什么不好，那就是如果你的工程非常简单，这么写会显得没有直接用 AFNetworking 将请求逻辑写在 Controller 中方便


YTKNetwork 使用基础教程：
https://github.com/yuantiku/YTKNetwork/blob/master/BasicGuide.md

YTKNetwork 使用高级教程：
https://github.com/yuantiku/YTKNetwork/blob/master/ProGuide.md



YTKNetwork 包括以下几个基本的类：

YTKNetworkConfig 类：用于统一设置网络请求的服务器和 CDN 的地址。
YTKRequest 类：所有的网络请求类需要继承于 YTKRequest 类，每一个YTKRequest 类的子类代表一种专门的网络请求。

我们为什么需要统一设置服务器地址呢？因为：

按照设计模式里的 Do Not Repeat Yourself原则，我们应该把服务器地址统一写在一个地方。
在实际业务中，我们的测试人员需要切换不同的服务器地址来测试。统一设置服务器地址到 YTKNetworkConfig 类中，也便于我们统一切换服务器地址。



每一种网络请求继承 YTKRequest 类后，需要用方法覆盖（overwrite）的方式，来指定网络请求的具体信息。





