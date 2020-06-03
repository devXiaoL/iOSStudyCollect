/**
 * Created by lilang on 2019-12-24.
 */

import React, { Component, useState, useEffect } from 'react';
import {Animated, Text, View, StyleSheet, TouchableOpacity} from 'react-native';

export default class App extends Component {
    constructor(props) {
        super(props);
        this.state = {
            title:'默认',
            hasError: false,
            opacity: new Animated.Value(0)// 透明度初始值设为0
        };
    }

    componentDidMount() {
        Animated.timing(                  // 随时间变化而执行动画
            this.state.opacity,                       // 动画中的变量值
            {
                toValue: 1,                   // 透明度最终变为1，即完全不透明
                duration: 3000,              // 让动画持续一段时间
            }
        ).start();                        // 开始执行动画
    }
    //当组件从 DOM 中移除时会调用如下方法
    componentWillUnmount() {

    }

    static getDerivedStateFromProps() {
        return null;
    }

    // 错误处理
    static getDerivedStateFromError() {
        return {hasError: true}
    }

    componentDidCatch(error, errorInfo) {
        console.log(error,errorInfo);
    }

    shouldComponentUpdate(nextProps, nextState, nextContext) {

    }

    setTest = () => {
        let mySet = new Set([1,2,3,1,4]);
        console.log(`mySet.size = ${mySet.size}`);

        mySet.add(5);

        console.log(`mySet arr = ${Array.from(mySet)}`);

        for (let [key, value] of mySet.entries()) {
            console.log(`key = ${key}, value = ${value}`);
        }
    }

    onPress = () => {
        this.setState({
            title: 'button clicked'
        });

        this.setTest();
    }

    render() {
        if (this.state.hasError) {
            return (
                <Text>页面渲染需要错误</Text>
            )
        }

        return (
            <View style={{...styles.container}}>
                <Text style={styles.text}> text Rn</Text>
                <Text style={styles.text}> {this.state.title}</Text>
                <TouchableOpacity
                    style = {styles.button}
                    onPress = {this.onPress}>
                    <Text style = {styles.buttonText}> TouchMe </Text>
                </TouchableOpacity>
                <Animated.View style={{justifyContent:'center', alignItems: 'center', height:100, width: 100, backgroundColor: 'red', opacity: this.state.opacity}}>
                    <Text style={{color: 'white'}}>淡入动画</Text>
                </Animated.View>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        flexDirection: "column",
    },
    text: {
        textAlign: "center",
        fontSize:(24),
        color:'red',
    },
    button: {
        marginTop: 40,
        justifyContent: 'center',
        backgroundColor: 'orange',
    },
    buttonText: {

        fontSize: 26,
        color: 'white'
    }
});