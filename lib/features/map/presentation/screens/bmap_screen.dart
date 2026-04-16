import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/map_provider.dart';
import '../../../alarm/presentation/screens/alarm_setup_screen.dart';

// TODO: 配置百度地图 Key 后，取消注释并导入
// import 'package:flutter_bmap/flutter_bmap.dart';

class BMapScreen extends StatelessWidget {
  const BMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('选择位置'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _showSearch(context);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // 百度地图组件
          // 配置 Key 后使用以下代码替换占位区域：
          //
          // BMapp(
          //   apiKey: '你的百度地图 Key',
          //   center: const LatLng(39.9042, 116.4074),
          //   zoom: 15.0,
          //   onMapCreated: (controller) {
          //     // 地图创建完成
          //   },
          //   onTap: (latLng) {
          //     // 点击地图选点
          //     context.read<MapProvider>().updateLocation(
          //       latLng.latitude,
          //       latLng.longitude,
          //     );
          //   },
          // )

          // 占位区域（配置 Key 前显示）
          Container(
            color: Colors.grey[200],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map,
                    size: 100,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '百度地图区域',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '配置百度地图 Key 后显示',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '请按照以下步骤配置：',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildStep('1. 访问 https://lbsyun.baidu.com/'),
                  _buildStep('2. 创建应用获取 AK'),
                  _buildStep('3. 编辑 AndroidManifest.xml'),
                  _buildStep('4. 编辑本文件取消注释'),
                ],
              ),
            ),
          ),

          // 中心标记
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.place,
                    color: Colors.red,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 8),
                Consumer<MapProvider>(
                  builder: (context, provider, child) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Text(
                        provider.address ?? '经纬度：${provider.latitude.toStringAsFixed(4)}, ${provider.longitude.toStringAsFixed(4)}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // 定位按钮
          Positioned(
            right: 16,
            bottom: 100,
            child: Consumer<MapProvider>(
              builder: (context, provider, child) {
                return FloatingActionButton(
                  mini: true,
                  onPressed: () {
                    provider.setLocating(true);
                    // 模拟定位
                    Future.delayed(const Duration(seconds: 1), () {
                      provider.setLocating(false);
                      provider.updateLocation(39.9042, 116.4074, address: '北京市朝阳区');
                    });
                  },
                  child: provider.isLocating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.my_location),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Consumer<MapProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AlarmSetupScreen(
                      latitude: provider.latitude,
                      longitude: provider.longitude,
                      address: provider.address,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add_location),
              label: const Text('在此处设置闹钟'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStep(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  void _showSearch(BuildContext context) {
    showSearch(
      context: context,
      delegate: BMapSearchDelegate(),
    );
  }
}

// 百度地图搜索代理
class BMapSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchList();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchList();
  }

  Widget _buildSearchList() {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.location_on),
          title: const Text('北京西站'),
          subtitle: const Text('北京市海淀区'),
          onTap: () => close(context, '北京西站'),
        ),
        ListTile(
          leading: const Icon(Icons.location_on),
          title: const Text('北京南站'),
          subtitle: const Text('北京市丰台区'),
          onTap: () => close(context, '北京南站'),
        ),
        ListTile(
          leading: const Icon(Icons.location_on),
          title: const Text('天安门广场'),
          subtitle: const Text('北京市东城区'),
          onTap: () => close(context, '天安门广场'),
        ),
      ],
    );
  }
}
