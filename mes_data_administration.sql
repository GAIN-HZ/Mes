/*
 Navicat Premium Dump SQL

 Source Server         : MySQL
 Source Server Type    : MySQL
 Source Server Version : 90400 (9.4.0)
 Source Host           : localhost:3306
 Source Schema         : mes_data_administration

 Target Server Type    : MySQL
 Target Server Version : 90400 (9.4.0)
 File Encoding         : 65001

 Date: 14/10/2025 16:12:04
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for t_basic_position
-- ----------------------------
DROP TABLE IF EXISTS `t_basic_position`;
CREATE TABLE `t_basic_position`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID（自增）',
  `equip_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '设备编码（外键，关联设备信息表t_equip_info）',
  `material_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '物料编码（外键，关联物料信息表t_material）',
  `area` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '区域（如设备上的物理区域划分）',
  `position` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '点位（SMT产线设备的具体物料放置点位）',
  `qty` int NOT NULL COMMENT '点位物料数量',
  `point` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '点位标识（文档中核心字段，补充遗漏）',
  `supply_spec` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '供应规格（文档中核心字段，补充遗漏）',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_t_basic_position_material`(`material_code` ASC) USING BTREE,
  INDEX `idx_t_basic_position_equip`(`equip_code` ASC) USING BTREE COMMENT '按设备编码查询点位索引',
  INDEX `idx_t_basic_position_equip_material`(`equip_code` ASC, `material_code` ASC) USING BTREE COMMENT '设备+物料联合查询点位索引',
  CONSTRAINT `t_basic_position_ibfk_1` FOREIGN KEY (`equip_code`) REFERENCES `t_equip_info` (`equip_code`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `t_basic_position_ibfk_2` FOREIGN KEY (`material_code`) REFERENCES `t_material` (`material_code`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'SMT产线专用，存储设备点位与物料对应关系（文档定义）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_basic_position
-- ----------------------------
INSERT INTO `t_basic_position` VALUES (1, 'CM602', 'SMT145700056', '1', '10005-1', 24, 'ANT1', '8');
INSERT INTO `t_basic_position` VALUES (2, 'CM602', 'SMT101000014', '2', '20007-1', 24, 'R201', '8');
INSERT INTO `t_basic_position` VALUES (3, 'CM602', 'SMT145700056', '3', '30005-1', 19, 'ANT2', '8');
INSERT INTO `t_basic_position` VALUES (4, 'CM602', 'SMT145700056', '4', '40005-1', 14, 'ANT3', '8');
INSERT INTO `t_basic_position` VALUES (5, 'BM', 'SMT145800033', '1', '41', 24, 'U201', '');

-- ----------------------------
-- Table structure for t_equip_info
-- ----------------------------
DROP TABLE IF EXISTS `t_equip_info`;
CREATE TABLE `t_equip_info`  (
  `equip_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '设备编码（主键，如“CM602-1”）',
  `model_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '设备型号编码（外键）',
  `workshop_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '车间编码（外键）',
  `line_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '产线编码（外键）',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '设备状态（运行/停机/维修）',
  `purchase_date` datetime NOT NULL COMMENT '采购日期',
  `last_maintain_date` datetime NULL DEFAULT NULL COMMENT '上次维护日期',
  PRIMARY KEY (`equip_code`) USING BTREE,
  INDEX `fk_t_equip_info_workshop`(`workshop_code` ASC) USING BTREE,
  INDEX `idx_t_equip_info_model`(`model_code` ASC) USING BTREE COMMENT '设备型号编码查询索引',
  INDEX `idx_t_equip_info_line_status`(`line_code` ASC, `status` ASC) USING BTREE COMMENT '产线+设备状态联合查询索引',
  CONSTRAINT `t_equip_info_ibfk_1` FOREIGN KEY (`model_code`) REFERENCES `t_equip_model` (`model_code`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `t_equip_info_ibfk_2` FOREIGN KEY (`workshop_code`) REFERENCES `t_workshop` (`workshop_code`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `t_equip_info_ibfk_3` FOREIGN KEY (`line_code`) REFERENCES `t_production_line` (`line_code`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '单台设备详情表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_equip_info
-- ----------------------------
INSERT INTO `t_equip_info` VALUES ('BM', 'BM', 'lyzcj002', 'lyzcx002', '闲置', '2024-07-24 00:00:00', '2024-07-24 00:00:00');
INSERT INTO `t_equip_info` VALUES ('CM602', 'CM602', 'lyzcj002', 'lyzcx002', '闲置', '2024-07-24 00:00:00', '2024-07-24 00:00:00');

-- ----------------------------
-- Table structure for t_equip_model
-- ----------------------------
DROP TABLE IF EXISTS `t_equip_model`;
CREATE TABLE `t_equip_model`  (
  `model_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '设备型号编码（主键）',
  `model_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '设备型号名称（如“CM602”“BM”）',
  `spec` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '设备规格',
  `manage_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '管理类型',
  `is_valid` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否有效（Y/N）',
  PRIMARY KEY (`model_code`) USING BTREE,
  INDEX `idx_t_equip_model_name`(`model_name` ASC) USING BTREE COMMENT '设备型号名称查询索引'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '设备型号基础信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_equip_model
-- ----------------------------
INSERT INTO `t_equip_model` VALUES ('BM', 'BM', NULL, NULL, 'Y');
INSERT INTO `t_equip_model` VALUES ('CM602', 'CM602', NULL, NULL, 'Y');
INSERT INTO `t_equip_model` VALUES ('lyzsb001', '烤箱', NULL, NULL, 'Y');
INSERT INTO `t_equip_model` VALUES ('lyzsb002', '恒温恒湿箱', NULL, NULL, 'Y');
INSERT INTO `t_equip_model` VALUES ('ysj001', '印刷机', NULL, NULL, 'Y');

-- ----------------------------
-- Table structure for t_material
-- ----------------------------
DROP TABLE IF EXISTS `t_material`;
CREATE TABLE `t_material`  (
  `material_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '物料编码（主键，如“SMT145700056”）',
  `material_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '物料名称（如“接触弹片”）',
  `spec` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '物料规格',
  `sku_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'SKU编码（外键）',
  `moisture_level_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '湿敏级别编码（外键）',
  `shelf_life_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '保质期方案编码（外键）',
  `warehouse_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '仓库编码（外键）',
  PRIMARY KEY (`material_code`) USING BTREE,
  INDEX `fk_t_material_moisture`(`moisture_level_code` ASC) USING BTREE,
  INDEX `fk_t_material_shelf_life`(`shelf_life_code` ASC) USING BTREE,
  INDEX `fk_t_material_warehouse`(`warehouse_code` ASC) USING BTREE,
  INDEX `idx_t_material_sku`(`sku_code` ASC) USING BTREE COMMENT 'SKU编码查询索引',
  INDEX `idx_t_material_name_spec`(`material_name` ASC, `spec` ASC) USING BTREE COMMENT '物料名称+规格联合查询索引',
  CONSTRAINT `t_material_ibfk_1` FOREIGN KEY (`sku_code`) REFERENCES `t_material_sku` (`sku_code`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `t_material_ibfk_2` FOREIGN KEY (`moisture_level_code`) REFERENCES `t_moisture_level` (`moisture_level_code`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `t_material_ibfk_3` FOREIGN KEY (`shelf_life_code`) REFERENCES `t_shelf_life` (`shelf_life_code`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `t_material_ibfk_4` FOREIGN KEY (`warehouse_code`) REFERENCES `t_warehouse` (`warehouse_code`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '物料核心属性表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_material
-- ----------------------------
INSERT INTO `t_material` VALUES ('33004070001', 'sku物料', '', 'sku001', 'lyz02', '111', 'ck01');
INSERT INTO `t_material` VALUES ('33004070002', '原材料2', '', 'sku001', 'lyz02', '111', 'ck01');
INSERT INTO `t_material` VALUES ('33004070003', '原材料3', '', 'sku001', 'lyz02', '111', 'ck01');
INSERT INTO `t_material` VALUES ('SMT101000014', '叠层电感', '2.7nH', 'sku001', 'lyz02', '111', 'ck01');
INSERT INTO `t_material` VALUES ('SMT145700056', '接触弹片', '1.0mm', 'sku001', 'lyz02', '111', 'ck01');
INSERT INTO `t_material` VALUES ('SMT145800033', '同轴连接器', '0.56mm', 'sku001', 'lyz02', '111', 'ck01');

-- ----------------------------
-- Table structure for t_material_sku
-- ----------------------------
DROP TABLE IF EXISTS `t_material_sku`;
CREATE TABLE `t_material_sku`  (
  `sku_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'SKU编码（主键）',
  `sku_desc` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'SKU描述',
  `is_valid` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否有效（Y/N）',
  PRIMARY KEY (`sku_code`) USING BTREE,
  INDEX `idx_t_material_sku_desc`(`sku_desc` ASC) USING BTREE COMMENT 'SKU描述查询索引'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '物料SKU定义表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_material_sku
-- ----------------------------
INSERT INTO `t_material_sku` VALUES ('sku0001', 'S码衣服', 'Y');
INSERT INTO `t_material_sku` VALUES ('sku001', 'sku1', 'Y');
INSERT INTO `t_material_sku` VALUES ('sku0011', '前加工', 'Y');
INSERT INTO `t_material_sku` VALUES ('sku002', 'sku2', 'Y');
INSERT INTO `t_material_sku` VALUES ('sku005', 'LED灯', 'Y');
INSERT INTO `t_material_sku` VALUES ('sku006', 'LED灯', 'Y');
INSERT INTO `t_material_sku` VALUES ('sku007', 'LED灯', 'Y');

-- ----------------------------
-- Table structure for t_moisture_level
-- ----------------------------
DROP TABLE IF EXISTS `t_moisture_level`;
CREATE TABLE `t_moisture_level`  (
  `moisture_level_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '湿敏级别编码（主键）',
  `moisture_level_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '湿敏级别名称',
  `is_valid` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否有效（Y/N）',
  PRIMARY KEY (`moisture_level_code`) USING BTREE,
  INDEX `idx_t_moisture_level_name`(`moisture_level_name` ASC) USING BTREE COMMENT '湿敏级别名称查询索引'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '物料湿敏级别定义表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_moisture_level
-- ----------------------------
INSERT INTO `t_moisture_level` VALUES ('lyz02', '8级别', 'Y');

-- ----------------------------
-- Table structure for t_process
-- ----------------------------
DROP TABLE IF EXISTS `t_process`;
CREATE TABLE `t_process`  (
  `process_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '工序编码（主键，如“lyzgx001（通用扫描）”）',
  `process_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '工序名称',
  `section_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '工艺段编码（外键）',
  `exec_time_control` int NULL DEFAULT NULL COMMENT '执行时间控制（分钟）',
  `is_collection` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否数据采集（Y/N）',
  `is_valid` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否有效（Y/N）',
  PRIMARY KEY (`process_code`) USING BTREE,
  INDEX `idx_t_process_section`(`section_code` ASC) USING BTREE COMMENT '工艺段编码查询索引',
  INDEX `idx_t_process_section_collection`(`section_code` ASC, `is_collection` ASC) USING BTREE COMMENT '工艺段+是否采集联合查询索引',
  CONSTRAINT `t_process_ibfk_1` FOREIGN KEY (`section_code`) REFERENCES `t_process_section` (`section_code`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '工序定义表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_process
-- ----------------------------
INSERT INTO `t_process` VALUES ('lyzgx001', '通用扫描', 'gyd001', 0, 'Y', 'Y');
INSERT INTO `t_process` VALUES ('lyzgx002', '通用QC（局胜制）', 'gyd001', 0, 'Y', 'Y');
INSERT INTO `t_process` VALUES ('lyzgx012', '通用QC（抽测工序）', 'gyd001', 0, 'Y', 'Y');

-- ----------------------------
-- Table structure for t_process_section
-- ----------------------------
DROP TABLE IF EXISTS `t_process_section`;
CREATE TABLE `t_process_section`  (
  `section_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '工艺段编码（主键，如“gyd001（通用类）”）',
  `section_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '工艺段名称',
  `section_category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '工艺段类别（通用类/SMT类）',
  `resource_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '资源类型',
  `is_valid` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否有效（Y/N）',
  PRIMARY KEY (`section_code`) USING BTREE,
  INDEX `idx_t_process_section_category`(`section_category` ASC) USING BTREE COMMENT '工艺段类别查询索引',
  INDEX `idx_t_process_section_resource`(`resource_type` ASC) USING BTREE COMMENT '资源类型查询索引'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '工艺段定义表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_process_section
-- ----------------------------
INSERT INTO `t_process_section` VALUES ('gyd001', '通用类', '通用类', '流水线', 'Y');
INSERT INTO `t_process_section` VALUES ('gyd002', 'SMT类', 'SMT类', '流水线', 'Y');
INSERT INTO `t_process_section` VALUES ('gyd003', '非IMS类', '非IMS类', '流水线', 'Y');

-- ----------------------------
-- Table structure for t_prod_proc_material
-- ----------------------------
DROP TABLE IF EXISTS `t_prod_proc_material`;
CREATE TABLE `t_prod_proc_material`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID（自增）',
  `product_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '产品编码（外键）',
  `process_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '工序编码（外键）',
  `material_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '物料编码（外键）',
  `is_main_material` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否主料（Y/N）',
  `material_qty` decimal(10, 2) NOT NULL COMMENT '物料用量',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_t_prod_proc_mat_material`(`material_code` ASC) USING BTREE,
  INDEX `idx_t_prod_proc_mat_product_process`(`product_code` ASC, `process_code` ASC) USING BTREE COMMENT '产品+工序联合查询索引',
  INDEX `idx_t_prod_proc_mat_process_material`(`process_code` ASC, `material_code` ASC) USING BTREE COMMENT '工序+物料联合查询索引',
  CONSTRAINT `t_prod_proc_material_ibfk_1` FOREIGN KEY (`product_code`) REFERENCES `t_product` (`product_code`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `t_prod_proc_material_ibfk_2` FOREIGN KEY (`process_code`) REFERENCES `t_process` (`process_code`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `t_prod_proc_material_ibfk_3` FOREIGN KEY (`material_code`) REFERENCES `t_material` (`material_code`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '产品-工序-物料绑定表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_prod_proc_material
-- ----------------------------
INSERT INTO `t_prod_proc_material` VALUES (1, '11002204007001', 'lyzgx001', '33004070001', 'Y', 1.00);
INSERT INTO `t_prod_proc_material` VALUES (2, '11002204007001', 'lyzgx001', '33004070002', 'Y', 1.00);
INSERT INTO `t_prod_proc_material` VALUES (3, '11002204007001', 'lyzgx001', '33004070003', 'Y', 1.00);

-- ----------------------------
-- Table structure for t_prod_proc_param
-- ----------------------------
DROP TABLE IF EXISTS `t_prod_proc_param`;
CREATE TABLE `t_prod_proc_param`  (
  `param_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '参数编码（主键）',
  `product_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '产品编码（外键）',
  `process_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '工序编码（外键）',
  `sampling_ratio_num` int NOT NULL COMMENT '抽样比例-分子',
  `sampling_ratio_den` int NOT NULL COMMENT '抽样比例-分母',
  `pass_rate_limit` decimal(5, 2) NOT NULL COMMENT '合格率下限（如99.50）',
  `fail_control_mode` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '失败控制方式',
  PRIMARY KEY (`param_code`) USING BTREE,
  INDEX `fk_t_prod_proc_param_process`(`process_code` ASC) USING BTREE,
  INDEX `idx_t_prod_proc_param_product_process`(`product_code` ASC, `process_code` ASC) USING BTREE COMMENT '产品+工序联合查询索引',
  CONSTRAINT `t_prod_proc_param_ibfk_1` FOREIGN KEY (`product_code`) REFERENCES `t_product` (`product_code`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `t_prod_proc_param_ibfk_2` FOREIGN KEY (`process_code`) REFERENCES `t_process` (`process_code`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '产品工序质检参数表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_prod_proc_param
-- ----------------------------
INSERT INTO `t_prod_proc_param` VALUES ('PW240423000018', '11002204007001', 'lyzgx012', 0, 0, 0.00, '不管控');
INSERT INTO `t_prod_proc_param` VALUES ('PW240426000001', '11002204007001', 'lyzgx002', 0, 0, 0.00, '不管控');

-- ----------------------------
-- Table structure for t_product
-- ----------------------------
DROP TABLE IF EXISTS `t_product`;
CREATE TABLE `t_product`  (
  `product_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '产品编码（主键）',
  `product_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '产品名称',
  `product_spec` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '产品规格',
  `is_valid` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否有效（Y/N）',
  PRIMARY KEY (`product_code`) USING BTREE,
  INDEX `idx_t_product_name`(`product_name` ASC) USING BTREE COMMENT '产品名称查询索引'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '产品基础信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_product
-- ----------------------------
INSERT INTO `t_product` VALUES ('11002204007001', '成品（通用类）', '通用类', 'Y');

-- ----------------------------
-- Table structure for t_product_bom
-- ----------------------------
DROP TABLE IF EXISTS `t_product_bom`;
CREATE TABLE `t_product_bom`  (
  `bom_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'BOM编码（主键）',
  `product_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '产品编码（外键）',
  `material_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '物料编码（外键）',
  `qty` decimal(10, 2) NOT NULL COMMENT '物料用量',
  `level` int NOT NULL COMMENT 'BOM层级（1=成品/2=半成品/3=原材料）',
  `is_substitute` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否替代物料（Y/N）',
  `bom_version` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'BOM版本',
  PRIMARY KEY (`bom_code`) USING BTREE,
  INDEX `idx_t_product_bom_product_level`(`product_code` ASC, `level` ASC) USING BTREE COMMENT '产品+层级联合查询索引',
  INDEX `idx_t_product_bom_material`(`material_code` ASC) USING BTREE COMMENT '物料编码查询索引',
  CONSTRAINT `t_product_bom_ibfk_1` FOREIGN KEY (`product_code`) REFERENCES `t_product` (`product_code`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `t_product_bom_ibfk_2` FOREIGN KEY (`material_code`) REFERENCES `t_material` (`material_code`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '产品物料清单表（支持多层级）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_product_bom
-- ----------------------------
INSERT INTO `t_product_bom` VALUES ('B240415000052', '11002204007001', '33004070001', 1.00, 1, 'N', '1.0');

-- ----------------------------
-- Table structure for t_production_line
-- ----------------------------
DROP TABLE IF EXISTS `t_production_line`;
CREATE TABLE `t_production_line`  (
  `line_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '产线编码（主键）',
  `line_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '产线名称（如“lyzcx002（SMT产线）”）',
  `workshop_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '车间编码（外键）',
  `process_section_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '工艺段编码（外键，关联t_process_section）',
  `line_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '产线类型（SMT/通用）',
  `is_valid` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否有效（Y/N）',
  PRIMARY KEY (`line_code`) USING BTREE,
  INDEX `idx_t_prod_line_workshop`(`workshop_code` ASC) USING BTREE COMMENT '车间编码查询索引',
  INDEX `idx_t_prod_line_workshop_type`(`workshop_code` ASC, `line_type` ASC) USING BTREE COMMENT '车间+产线类型联合查询索引',
  CONSTRAINT `t_production_line_ibfk_1` FOREIGN KEY (`workshop_code`) REFERENCES `t_workshop` (`workshop_code`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '产线基础信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_production_line
-- ----------------------------
INSERT INTO `t_production_line` VALUES ('lyzcx001', '通用类产线', 'lyzcj001', 'gyd001', '通用', 'Y');
INSERT INTO `t_production_line` VALUES ('lyzcx002', 'SMT产线', 'lyzcj002', 'gyd002', 'SMT', 'Y');
INSERT INTO `t_production_line` VALUES ('lyzcx003', '通用产线1', 'lyzcj001', 'gyd001', '通用', 'Y');
INSERT INTO `t_production_line` VALUES ('lyzcx004', 'SMT产线4', 'lyzcj002', 'gyd002', 'SMT', 'Y');

-- ----------------------------
-- Table structure for t_shelf_life
-- ----------------------------
DROP TABLE IF EXISTS `t_shelf_life`;
CREATE TABLE `t_shelf_life`  (
  `shelf_life_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '保质期方案编码（主键）',
  `shelf_life_desc` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '保质期方案描述',
  `days` int NOT NULL COMMENT '保质期天数',
  `is_valid` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否有效（Y/N）',
  PRIMARY KEY (`shelf_life_code`) USING BTREE,
  INDEX `idx_t_shelf_life_days`(`days` ASC) USING BTREE COMMENT '保质期天数查询索引'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '物料保质期方案定义表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_shelf_life
-- ----------------------------
INSERT INTO `t_shelf_life` VALUES ('111', '1天', 20, 'Y');

-- ----------------------------
-- Table structure for t_spare_info
-- ----------------------------
DROP TABLE IF EXISTS `t_spare_info`;
CREATE TABLE `t_spare_info`  (
  `spare_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '备件编码（主键，如“beijian001-1”）',
  `spare_model_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '备件型号编码（外键）',
  `warehouse_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '仓库编码（外键）',
  `loc_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '储位编码（外键）',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '备件状态（在用/闲置/报废）',
  `use_count` int NOT NULL DEFAULT 0 COMMENT '使用次数',
  PRIMARY KEY (`spare_code`) USING BTREE,
  INDEX `fk_t_spare_info_warehouse`(`warehouse_code` ASC) USING BTREE,
  INDEX `fk_t_spare_info_loc`(`loc_code` ASC) USING BTREE,
  INDEX `idx_t_spare_info_model`(`spare_model_code` ASC) USING BTREE COMMENT '备件型号编码查询索引',
  INDEX `idx_t_spare_info_use_count`(`use_count` ASC) USING BTREE COMMENT '使用次数查询索引',
  CONSTRAINT `t_spare_info_ibfk_1` FOREIGN KEY (`spare_model_code`) REFERENCES `t_spare_model` (`spare_model_code`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `t_spare_info_ibfk_2` FOREIGN KEY (`warehouse_code`) REFERENCES `t_warehouse` (`warehouse_code`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `t_spare_info_ibfk_3` FOREIGN KEY (`loc_code`) REFERENCES `t_storage_loc` (`loc_code`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '单个备件详情表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_spare_info
-- ----------------------------
INSERT INTO `t_spare_info` VALUES ('beijian006', 'beijian001', 'ck04', 'cw004', '在库', 0);
INSERT INTO `t_spare_info` VALUES ('beijian007', 'beijian001', 'ck04', 'cw005', '在库', 0);

-- ----------------------------
-- Table structure for t_spare_model
-- ----------------------------
DROP TABLE IF EXISTS `t_spare_model`;
CREATE TABLE `t_spare_model`  (
  `spare_model_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '备件型号编码（主键）',
  `model_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '备件型号名称（如“beijian001（供料器）”）',
  `spare_category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '备件类别',
  `repair_mode` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '维修方式',
  `supply_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '供应类型',
  PRIMARY KEY (`spare_model_code`) USING BTREE,
  INDEX `idx_t_spare_model_category`(`spare_category` ASC) USING BTREE COMMENT '备件类别查询索引'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '备件型号基础信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_spare_model
-- ----------------------------
INSERT INTO `t_spare_model` VALUES ('beijian001', '供料器', '供料器', '可维修', NULL);
INSERT INTO `t_spare_model` VALUES ('beijian002', '供料器', '供料器', '可维修', NULL);

-- ----------------------------
-- Table structure for t_storage_loc
-- ----------------------------
DROP TABLE IF EXISTS `t_storage_loc`;
CREATE TABLE `t_storage_loc`  (
  `loc_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '储位编码（主键）',
  `warehouse_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '仓库编码（外键）',
  `area_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '区域编码',
  `shelf_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '货架编码',
  `loc_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '储位状态（空闲/占用/异常）',
  `abnormal_info` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '异常信息',
  PRIMARY KEY (`loc_code`) USING BTREE,
  INDEX `idx_t_storage_loc_warehouse`(`warehouse_code` ASC) USING BTREE COMMENT '仓库编码查询索引',
  INDEX `idx_t_storage_loc_warehouse_area`(`warehouse_code` ASC, `area_code` ASC) USING BTREE COMMENT '仓库+区域联合查询索引',
  CONSTRAINT `t_storage_loc_ibfk_1` FOREIGN KEY (`warehouse_code`) REFERENCES `t_warehouse` (`warehouse_code`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '储位基础信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_storage_loc
-- ----------------------------
INSERT INTO `t_storage_loc` VALUES ('cw004', 'ck04', NULL, NULL, '未知', NULL);
INSERT INTO `t_storage_loc` VALUES ('cw005', 'ck04', NULL, NULL, '未知', NULL);
INSERT INTO `t_storage_loc` VALUES ('cw01', 'ck01', NULL, NULL, '未知', NULL);
INSERT INTO `t_storage_loc` VALUES ('cw02', 'ck01', NULL, NULL, '未知', NULL);

-- ----------------------------
-- Table structure for t_tool_info
-- ----------------------------
DROP TABLE IF EXISTS `t_tool_info`;
CREATE TABLE `t_tool_info`  (
  `tool_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '工装编码（主键，如“lyzgz001-1”）',
  `tool_model_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '工装型号编码（外键）',
  `warehouse_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '仓库编码（外键）',
  `loc_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '储位编码（外键）',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '工装状态（在用/闲置/维修）',
  `last_maintain_date` datetime NULL DEFAULT NULL COMMENT '上次维护日期',
  PRIMARY KEY (`tool_code`) USING BTREE,
  INDEX `fk_t_tool_info_loc`(`loc_code` ASC) USING BTREE,
  INDEX `idx_t_tool_info_model`(`tool_model_code` ASC) USING BTREE COMMENT '工装型号编码查询索引',
  INDEX `idx_t_tool_info_warehouse_loc`(`warehouse_code` ASC, `loc_code` ASC) USING BTREE COMMENT '仓库+储位联合查询索引',
  CONSTRAINT `t_tool_info_ibfk_1` FOREIGN KEY (`tool_model_code`) REFERENCES `t_tool_model` (`tool_model_code`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `t_tool_info_ibfk_2` FOREIGN KEY (`warehouse_code`) REFERENCES `t_warehouse` (`warehouse_code`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `t_tool_info_ibfk_3` FOREIGN KEY (`loc_code`) REFERENCES `t_storage_loc` (`loc_code`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '单套工装详情表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_tool_info
-- ----------------------------
INSERT INTO `t_tool_info` VALUES ('lyzgz002', 'lyzgz001', 'ck04', 'cw004', '在库', '2024-07-24 00:00:00');
INSERT INTO `t_tool_info` VALUES ('lyzgz003', 'lyzgz001', 'ck04', 'cw005', '在库', '2024-07-24 00:00:00');

-- ----------------------------
-- Table structure for t_tool_model
-- ----------------------------
DROP TABLE IF EXISTS `t_tool_model`;
CREATE TABLE `t_tool_model`  (
  `tool_model_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '工装型号编码（主键）',
  `model_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '工装型号名称（如“lyzgz001（模治具）”）',
  `tool_category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '工装类别',
  `maintain_cycle` int NOT NULL COMMENT '维护周期（天数）',
  `is_calibrate` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否需要校准（Y/N）',
  PRIMARY KEY (`tool_model_code`) USING BTREE,
  INDEX `idx_t_tool_model_category`(`tool_category` ASC) USING BTREE COMMENT '工装类别查询索引'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '工装型号基础信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_tool_model
-- ----------------------------
INSERT INTO `t_tool_model` VALUES ('guadao', '刮刀', '刮刀', 0, 'N');
INSERT INTO `t_tool_model` VALUES ('gw001', '钢网', '钢网', 0, 'N');
INSERT INTO `t_tool_model` VALUES ('lyzgz001', '模治具', '模治具', 0, 'N');
INSERT INTO `t_tool_model` VALUES ('lyzgz002', '模治具2', '模治具', 0, 'N');

-- ----------------------------
-- Table structure for t_warehouse
-- ----------------------------
DROP TABLE IF EXISTS `t_warehouse`;
CREATE TABLE `t_warehouse`  (
  `warehouse_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '仓库编码（主键）',
  `warehouse_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '仓库名称（如“良品仓”“报废仓”）',
  `warehouse_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '仓库类型',
  `attribute` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '仓库属性',
  `is_virtual` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否虚拟仓库（Y/N）',
  `is_valid` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否有效（Y/N）',
  PRIMARY KEY (`warehouse_code`) USING BTREE,
  INDEX `idx_t_warehouse_name`(`warehouse_name` ASC) USING BTREE COMMENT '仓库名称查询索引',
  INDEX `idx_t_warehouse_type`(`warehouse_type` ASC) USING BTREE COMMENT '仓库类型查询索引'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '仓库基础信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_warehouse
-- ----------------------------
INSERT INTO `t_warehouse` VALUES ('ck01', '良品仓库（原材料）', '良品仓', '物料类', 'N', 'Y');
INSERT INTO `t_warehouse` VALUES ('ck02', '不良品仓库', '不良品仓', '物料类', 'N', 'Y');
INSERT INTO `t_warehouse` VALUES ('ck03', '报废仓', '报废仓', '物料类', 'N', 'Y');
INSERT INTO `t_warehouse` VALUES ('ck04', '资产仓', '良品仓', '其它资产类', 'N', 'Y');
INSERT INTO `t_warehouse` VALUES ('ck05', '良品仓（成品）', '良品仓', '物料类', 'N', 'Y');

-- ----------------------------
-- Table structure for t_workshop
-- ----------------------------
DROP TABLE IF EXISTS `t_workshop`;
CREATE TABLE `t_workshop`  (
  `workshop_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '车间编码（主键）',
  `workshop_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '车间名称（如“A车间（通用类）”）',
  `is_valid` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否有效（Y/N）',
  PRIMARY KEY (`workshop_code`) USING BTREE,
  INDEX `idx_t_workshop_name`(`workshop_name` ASC) USING BTREE COMMENT '车间名称查询索引'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '车间基础信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_workshop
-- ----------------------------
INSERT INTO `t_workshop` VALUES ('lyzcj001', 'A车间（通用类）', 'Y');
INSERT INTO `t_workshop` VALUES ('lyzcj002', 'B车间（SMT类）', 'Y');

SET FOREIGN_KEY_CHECKS = 1;
