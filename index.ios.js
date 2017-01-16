'use strict';

import React from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  TouchableOpacity,
  NativeModules
} from 'react-native';

import CodePush from "react-native-code-push";

var BTRNManager = NativeModules.BTRNManager;

class WelcomeView extends React.Component {
    componentDidMount(){
        CodePush.sync();
    }
    render() {
        return (
            <View style={styles.container}>
                <Text style={styles.scores}>
                    由于个人时间不足，需要更多的开发者来一起维护这一个应用，如果你想加入我们，可以联系我们，email：cbyniypeu@163.com，期待你的加入。
                </Text>
                <TouchableOpacity
                    onPress={()=>BTRNManager.DismissViewController(true)}>
                    <Text  style={styles.highScoresTitle}>返回</Text>
                </TouchableOpacity>
            </View>
        );
    }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#FFFFFF',
  },
  highScoresTitle: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  scores: {
    textAlign: 'center',
    color: '#333333',
    margin: 15,
  },
});

// 整体js模块的名称
AppRegistry.registerComponent('WelcomeView', () => WelcomeView);
