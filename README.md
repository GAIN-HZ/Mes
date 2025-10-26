# MES 后端系统前端对接 README 文档


## 一、引言
本文档用于指导前端开发者快速对接 MES 后端系统，明确对接所需的环境配置、接口使用规则及常见问题解决方案。

后端系统基于 Spring Boot 2.7.18 + MyBatis-Plus 3.5.3.1 开发，已实现设备管理、部门管理等核心功能，数据库连接稳定，接口可直接调用，助力前端快速开发联动。


## 二、后端部署前置配置（前端无需操作，供后端移植参考）
### （一）Maven 本地配置
1. 打开项目根目录下的 pom.xml，确保 Maven 仓库配置为本地路径（避免依赖拉取失败）。
2. 若需修改 Maven 配置，可在 IDEA 中进入 File → Settings → Build, Execution, Deployment → Build Tools → Maven，选择本地 Maven 安装路径及配置文件。

### （二）JDK 与语言等级配置
1. JDK 版本：项目需使用 JDK 1.8（推荐 Dragonwell-ex 1.8.0_452）。
   ◦在 IDEA 中进入 File → Project Structure → Project，将 Project SDK 选择为 JDK 1.8。
   ◦进入 Modules → Sources，将 Language Level 设置为 8 - Lambdas, type annotations etc.。

### （三）数据库配置修改
打开 src/main/resources/application.yml，修改数据库账号和密码以匹配本地环境：

spring:
  datasource:
    url: jdbc:mysql://localhost:3306/mes_data_administration?useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true
    username: 你的数据库用户名 # 例如 root
    password: 你的数据库密码     # 例如 0411
    driver-class-name: com.mysql.cj.jdbc.Driver


## 三、前端对接准备工作
### （一）环境要求
1. 后端运行环境：Java 1.8（需确保后端服务已按上述配置启动）。
2. 前端开发环境：Node.js 14+（适配主流前端框架如 Vue、React），浏览器建议使用 Chrome 90+ 或 Firefox 88+。
3. 网络要求：前后端需处于同一网络环境，确保前端能访问后端服务器（默认本地地址 localhost:8080）。

### （二）工具准备
1. 接口测试工具：Postman、Apifox 等，用于提前验证接口可用性。
2. 开发工具：VS Code（推荐安装 REST Client 插件快速测试接口）、WebStorm 等前端编辑器。
3. 辅助工具：数据库客户端（如 Navicat），用于核对接口返回数据与数据库存储一致性。


## 四、对接配置步骤
### （一）后端服务确认
1. 启动后端服务：运行 com.gxt.mesbackend.MesBackendApplication 启动类，控制台输出 Tomcat started on port(s): 8080 (http) with context path '/mes' 即为启动成功。
2. 验证服务可用性：请勿直接访问 http://localhost:8080/mes（此路径无资源页，会 404），需访问具体接口（如 http://localhost:8080/mes/basic/equip/list），返回 JSON 格式数据则说明服务正常。

### （二）跨域配置（关键）
若前端项目与后端不在同一端口 / 域名，后端已内置跨域配置（若需调整可参考以下代码）：

package com.gxt.mesbackend.config;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
@Configuration
public class CorsConfig implements WebMvcConfigurer {
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**") // 允许所有接口跨域
                .allowedOrigins("*") // 允许所有前端域名（生产环境建议指定具体域名）
                .allowedMethods("GET", "POST", "PUT", "DELETE") // 允许的请求方式
                .allowedHeaders("*") // 允许所有请求头
                .maxAge(3600); // 预检请求缓存时间
    }
}

### （三）接口基础配置
1. 接口根路径：http://localhost:8080/mes（所有接口均基于此路径拼接，根路径无资源页，需访问具体接口路径）。
2. 数据格式：请求 / 响应均为 JSON，POST/PUT 请求需设置请求头 Content-Type: application/json。
3. 状态码规则：200 = 请求成功，400 = 参数错误，404 = 接口不存在，500 = 服务器异常。


## 五、接口使用方法
### （一）已实现核心接口（直接调用）
1. 设备列表查询
•接口地址：/basic/equip/list
•请求方式：GET
•接口描述：查询所有设备信息（已验证可用）
•响应示例：

{
  "code": 200,
  "msg": "查询成功",
  "data": [
    {
      "equipCode": "EQUIP001",
      "equipName": "加工中心",
      "workshopCode": "WS001",
      "status": 1, // 1=正常，2=维修，3=停用
      "createTime": "2025-10-26 08:00:00"
    }
  ],
  "total": 1
}

2. 部门相关接口

接口功能	接口地址	请求方式	请求参数	响应说明
查询所有部门	/api/department	GET	无	返回所有有效部门列表
新增部门	/api/department	POST	-body：deptCode（必填）、deptName（必填）等	返回新增部门 ID 及基础信息
查询单个部门	/api/department/{id}	GET	路径参数 id（部门主键）	返回单个部门完整信息
修改部门	/api/department/{id}	PUT	路径参数 id + body（需修改的字段）	返回修改成功提示及更新信息
删除部门	/api/department/{id}	DELETE	路径参数 id（部门主键）	返回删除成功提示

### （二）前端请求示例（Axios）
1. 安装 Axios：npm install axios --save
2. 基础请求配置：

import axios from 'axios';
// 创建 axios 实例
const service = axios.create({
  baseURL: 'http://localhost:8080/mes', // 接口根路径
  timeout: 5000, // 请求超时时间
  headers: {
    'Content-Type': 'application/json'
  }
});
// 请求拦截器：可添加 token、请求日志等
service.interceptors.request.use(
  (config) => {
    // 示例：若需登录验证，可在此处添加 token（根据实际业务调整）
    // const token = localStorage.getItem('token');
    // if (token) {
    //   config.headers['Authorization'] = `Bearer ${token}`;
    // }
    return config;
  },
  (error) => {
    // 请求错误处理
    console.error('请求拦截器错误：', error);
    return Promise.reject(error);
  }
);
// 响应拦截器：统一处理响应结果
service.interceptors.response.use(
  (response) => {
    const res = response.data;
    // 根据后端状态码判断请求结果
    if (res.code !== 200) {
      // 非 200 状态码视为请求失败（如参数错误、业务异常）
      console.error(`接口请求失败：${res.msg || '未知错误'}`);
      return Promise.reject(res);
    } else {
      // 200 状态码直接返回数据
      return res.data;
    }
  },
  (error) => {
    // 网络错误、500 等异常处理
    console.error('响应拦截器错误：', error);
    let errorMsg = '网络异常，请检查连接或联系管理员';
    if (error.response) {
      switch (error.response.status) {
        case 404:
          errorMsg = '接口不存在，请核对路径（注意根路径无资源页）';
          break;
        case 500:
          errorMsg = '服务器内部错误，请稍后重试';
          break;
        case 403:
          errorMsg = '权限不足，无法访问';
          break;
        default:
          errorMsg = `请求错误（${error.response.status}）`;
      }
    }
    return Promise.reject({ code: -1, msg: errorMsg });
  }
);
// -------------------------- 核心接口封装 --------------------------
/**
 * 设备管理接口
 */
// 1. 查询所有设备列表
export function getEquipList() {
  return service({
    url: '/basic/equip/list',
    method: 'get'
  });
}
/**
 * 部门管理接口
 */
// 1. 查询所有部门
export function getDepartmentList() {
  return service({
    url: '/api/department',
    method: 'get'
  });
}
// 2. 新增部门
// data 参数示例：{ deptCode: 'DEPT003', deptName: '质量部', parentDeptCode: 'ROOT', workshopCode: 'WS003', isValid: 1 }
export function addDepartment(data) {
  return service({
    url: '/api/department',
    method: 'post',
    data
  });
}
// 3. 根据 ID 查询单个部门
// id：部门主键 ID（如 1、2）
export function getDepartmentById(id) {
  return service({
    url: `/api/department/${id}`,
    method: 'get'
  });
}
// 4. 修改部门信息
// id：部门主键 ID；data：需修改的字段（如 { deptName: '技术研发部', isValid: 1 }）
export function updateDepartment(id, data) {
  return service({
    url: `/api/department/${id}`,
    method: 'put',
    data
  });
}
// 5. 删除部门
// id：部门主键 ID
export function deleteDepartment(id) {
  return service({
    url: `/api/department/${id}`,
    method: 'delete'
  });
}
export default service;

### （三）数据处理说明
1. 接口返回数据结构统一包含 code（状态码）、msg（提示信息）、data（业务数据），前端可根据 code 判断请求结果。
2. 字段映射：后端返回字段与数据库表字段一致（如部门表 deptCode 对应部门编码、isValid 表示是否有效（1 = 有效，0 = 无效））。
3. 空数据处理：若接口返回 data 为 empty array，说明数据库对应表无数据，前端可展示 “暂无数据” 提示。


## 六、常见问题及解决方法
### （一）接口访问 404
•原因：接口路径错误、后端服务未启动，或直接访问根路径http://localhost:8080/mes（此路径无资源页）。
•解决：核对接口路径是否拼接根路径 /mes 且为具体接口路径；确认后端服务已启动，且控制台无报错。

### （二）跨域请求报错（CORS）
•原因：后端未配置跨域或配置有误。
•解决：检查后端是否添加 CorsConfig 配置类；前端请求确保未遗漏 Content-Type 头。

### （三）接口返回 500 错误
•原因：后端服务异常（如数据库连接失败、参数格式错误）。
•解决：查看后端控制台日志，根据报错信息排查（如数据库账号密码错误、请求参数缺失必填项）。

### （四）接口返回数据为空
•原因：数据库对应表无数据或查询条件不匹配。
•解决：通过 Navicat 查看 t_equip（设备表）、t_department（部门表）是否有数据；核对请求参数是否正确。


## 七、注意事项
1. 接口路径区分大小写，需严格按照文档中的路径拼写（如 /basic/equip/list 不可写为 /basic/Equip/List）。
2. POST/PUT 请求的必填参数需确保传递，否则会返回 400 参数错误。
3. 开发环境建议开启后端 SQL 日志（参考文档前文配置），便于排查数据查询问题。
4. 若需扩展接口或修改字段，可联系后端开发者协调调整。


## 八、联系方式
若对接过程中遇到问题，可联系后端开发者核对配置或排查接口问题，高效推进开发进度。



