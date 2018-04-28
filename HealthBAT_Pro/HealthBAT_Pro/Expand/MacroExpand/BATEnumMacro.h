//
//  BATEnumMacro.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/29.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#ifndef BATEnumMacro_h
#define BATEnumMacro_h

#pragma mark - 推荐好友
/**
 *  推荐类型
 */
typedef NS_ENUM(NSInteger, BATRecommendType) {
    /**
     *  好友
     */
    BATRecommendFriends = 1,
    /**
     *  医生
     */
    BATRecommendDoctors = 2,
    /**
     *  感兴趣的人
     */
    BATRecommendHobby = 3,
};

#pragma mark - 搜索关键字类型
/**
 *  推荐类型
 *0=正常输入；
 *1=联想；
 *2=热词
 */
typedef NS_ENUM(NSInteger, BATkeywordSource) {
    /**
     *  正常
     */
    BATkeywordSourceNoromalwords = 0,
    /**
     *  联想
     */
    BATkeywordSourceRelateWords = 1,
    /**
     *  热词
     */
    BATkeywordSourceHotWords = 2,
};

#pragma mark - 搜索疾病详情
/**
 *  选择类型
 *0=简介；
 *1=相关症状；
 *2=并发症
 *3=易感人群；
 *4=治愈率；
 *5=检查方式
 *6=治疗方式；
 *7=预防护理；
 */
typedef NS_ENUM(NSInteger, BATSearchType) {
    /**
     *  简介
     */
    BATSearchBrief = 0,
    /**
     *  相关症状
     */
    BATSearchRelateTreatment = 1,
    /**
     *  并发症
     */
    BATSearchcomplication = 2,
    /**
     *  易感人群
     */
    BATSearchinfect = 3,
    /**
     *  治愈率
     */
    BATSearchCure = 4,
    /**
     *  检查方式
     */
    BATSearchTestMode = 5,
    /**
     *  治疗方式
     */
    BATSearchTherapyMethod = 6,
    /**
     *  预防护理
     */
    BATSearchPrevent = 7,
};
#pragma mark - 培训工作室护理类型

typedef NS_ENUM(NSInteger, BATSearchTrainingSubjectType) {
    /**
     *  全部
     */
    BATSearchTrainingSubjectTypeAll = -1,
    /**
     *  养老护理
     */
    BATSearchTrainingSubjectTypePension = 0,
    /**
     *  护理学
     */
    BATSearchTrainingSubjectTypeNursing = 1,
    /**
     * 内科护理
     */
    BATSearchTrainingSubjectTypeInternalMedicine = 2,
    /**
     *  外科护理
     */
    BATSearchTrainingSubjectTypeSurgical = 3,
    /**
     *  妇产科护理
     */
    BATSearchTrainingSubjectTypeGynecology = 4,
    /**
     *  儿童科护理
     */
    BATSearchTrainingSubjectTypePediatric = 5,
    /**
     *  社区护理
     */
    BATSearchTrainingSubjectTypeCommunity = 6,
    
};

#pragma mark - 搜索
/**
 *  搜索类型
 */
typedef NS_ENUM(NSInteger, kSearchType) {
    /**
     *  全部
     */
    kSearchAll = 0,
    /**
     *  疾病
     */
    kSearchCondition,
    /**
     *  症状
     */
    kSearchSymptom,
    /**
     *  药品
     */
    kSearchTreatment,
    /**
     *  医院
     */
    kSearchHospital,
    /**
     *  养老院
     */
    kSearchGeracomium,
    /**
     *  医生
     */
    kSearchDoctor,
    /**
     *  资讯
     */
    kSearchInformation,
};

#pragma mark 健康圈-群组详情
/**
 *  群组详情获取动态操作enum
 */
typedef NS_ENUM(NSInteger, BATGroupDetailDynamicOpration) {
    /**
     *  全部
     */
    BATGroupDetailDynamicOprationAll = -1,
    /**
     *  动态
     */
    BATGroupDetailDynamicOprationDynamic = 0,
    /**
     *  问题
     */
    BATGroupDetailDynamicOprationQuestion = 1,
};


#pragma mark - 咨询－咨询类型
/**
 *  咨询类型
 */
typedef NS_ENUM(NSInteger, ConsultType) {
    /**
     *  免费
     */
    kConsultTypeFree              = 0,
    /**
     *  图文
     */
    kConsultTypeTextAndImage      = 1,
    
    /**
     *  视频
     */
    kConsultTypeVideo             = 2,
    
    /**
     *  语音
     */
    kConsultTypeAudio             = 3,
    /**
     *  上门
     */
//    kConsultTypeGoHome            = 4,
};

/**
 *  资讯类型
 */
typedef NS_ENUM(NSInteger, HomeNewsType) {
    
    /**
     *  推荐
     */
    kHomeNewsRecommend         = 10,
    /**
     *  热门
     */
    kHomeNewsHot               = 11,
    
};

/**
 *  医生服务类型
 */
typedef NS_ENUM(NSInteger, DoctorServerType) {
    /**
     *  图文
     */
    kDoctorServerWordImageType = 1,
    /**
     *  语音
     */
    kDoctorServerAudioType = 2,
    /**
     *  视频
     */
    kDoctorServerVideoType = 3,
    /**
     *  家庭医生
     */
    kDoctorServerHomeDoctor = 4,
    /**
     *  远程会诊
     */
    kDoctorServerRemote = 5,
};

/**
 收藏类型
 
 - kBATCollectionLinkTypeDoctor:   医生
 - kBATCollectionLinkTypeHospital: 医院
 - kBATCollectionLinkTypeNews:     资讯
 - kBATCollectionLinkTypeDynamic:  动态
 - kBATCollectionLinkTypeCare:     关心
 - kBATCollectionLinkTypeCourse:   课程
 */
typedef NS_ENUM(NSInteger, BATCollectionLinkType) {
    kBATCollectionLinkTypeDoctor = 1,
    kBATCollectionLinkTypeHospital = 2,
    kBATCollectionLinkTypeNews = 3,
    kBATCollectionLinkTypeDynamic = 4,
    kBATCollectionLinkTypeCare = 5,
    kBATCollectionLinkTypeCourse = 6,
    kBATCollectionLinkTypeCourseCommentLike = 7,
};


/**
 课程类型
 
 - kBATCourseType_Video: 视频
 - kBATCourseType_WordOrPDF: Word/pdf
 */
typedef NS_ENUM(NSInteger, BATCourseType)
{
    kBATCourseType_Video = 1,
    kBATCourseType_WordOrPDF = 2,
};

/**
 消息类型
 - kBATMessageType_System  系统消息
 - kBATMessageType_OnduryDoctor 值班医生
 - kBATMessageType_ConsultingDoctor 咨询医生
 - kBATMessageType_Teacher 教师
 */
typedef NS_ENUM(NSInteger, BATMessageType)
{
    kBATMessageType_System = 1,
    kBATMessageType_OnduryDoctor = 2,
    kBATMessageType_ConsultingDoctor = 3,
    kBATMessageType_Teacher = 4,
    kBATMessageType_FamilyDoctor = 5,
};


/**
 体质类型
 - kBATPhysicalType_YangXuZhi = 1,阳虚质
 - kBATPhysicalType_YinXuZhi = 2,阴虚质
 - kBATPhysicalType_QiXuZhi = 3,气虚质
 - kBATPhysicalType_TanShiZhi = 4,痰湿质
 - kBATPhysicalType_WenShiZhi = 5,湿热质
 - kBATPhysicalType_QiYuZhi = 6,气郁质
 - kBATPhysicalType_XueYuZhi = 7,血瘀质
 - kBATPhysicalType_TeBinZhi = 8,特禀质
 - kBATPhysicalType_PingHeZhi = 9,平和质
 - kBATPhysicalType_PingHeJianQiTa = 10,平和质或其他
 */
typedef NS_ENUM(NSInteger, BATPhysicalType)
{
    kBATPhysicalType_YangXuZhi = 42,
    kBATPhysicalType_YinXuZhi = 44,
    kBATPhysicalType_QiXuZhi = 46,
    kBATPhysicalType_TanShiZhi = 47,
    kBATPhysicalType_ShiReZhi = 48,
    kBATPhysicalType_QiYuZhi = 50,
    kBATPhysicalType_XueYuZhi = 51,
    kBATPhysicalType_TeBingZhi = 52,
    kBATPhysicalType_PingHeZhi = 53,
    kBATPhysicalType_PingHeJianQiTa = 54,
};




/**
 轮播图跳转类型
 
 - kBATHomeADType_H5: H5
 - kBATHomeADType_DrKang: 康博士
 - kBATHomeADType_Guoyiguan: 国医馆
 - kBATHomeADType_Assessment: 健康评测
 - kBATHomeADType_Mall: 健康商城
 - kBATHomeADType_FollowVideo: 健康关注视频
 - kBATHomeADType_News: 健康资讯
 */
typedef NS_ENUM(NSInteger, BATHomeADType)
{
    kBATHomeADType_None = 0,
    kBATHomeADType_H5 = 1,
    kBATHomeADType_DrKang = 2,
    kBATHomeADType_Guoyiguan = 3,
    kBATHomeADType_Assessment = 4,
    kBATHomeADType_Mall = 5,
    kBATHomeADType_FollowVideo = 6,
    kBATHomeADType_News = 7,
    kBATHomeADType_Find = 8,
};


/**
 课程详细-评论
 
 - kBATCourseDetailCommentType_Nomal: 初始状态
 - kBATCourseDetailCommentType_CanInput: 可输入状态
 */
typedef NS_ENUM(NSInteger, BATCourseDetailCommentType)
{
    kBATCourseDetailCommentType_Nomal = 0,
    kBATCourseDetailCommentType_CanInput = 1,
};

/**
 健康关注方案类型
 
 - kBATHealtFocusProgramType_Beauty: 美容
 - kBATHealtFocusProgramType_KeepHealth: 养生
 - kBATHealtFocusProgramType_LoseWeight: 减肥
 - kBATHealtFocusProgramType_CurvyBody : 塑型
 */
typedef NS_ENUM(NSInteger, BATHealtFocusProgramType)
{
    kBATHealtFocusProgramType_KeepHealth = 1,
    kBATHealtFocusProgramType_LoseWeight = 2,
    kBATHealtFocusProgramType_Beauty = 3,
    kBATHealtFocusProgramType_CurvyBody = 4,
    
};
/**
 健康关注
 
 - kBATHealtFocusBeautyType: 美容
 - kBATHealtFocusKeepHealthType: 养生
 - kBATHealtFocusLoseWeight: 减肥
 */
typedef NS_ENUM(NSInteger, BATHealtFocusType)
{
    kBATHealtFocusBeautyType = 1,
    kBATHealtFocusKeepHealthType = 2,
    kBATHealtFocusLoseWeight = 3,
};

#pragma mark -  家庭医生
/**
 家庭医生服务类型
 
 BATFamilyDoctorServiceVideo 视频,
 BATFamilyDoctorServiceVoice 声音,
 BATFamilyDoctorServiceTextAndImage 图文,
 BATFamilyDoctorServiceGoHome 上门,
 */
typedef NS_ENUM(NSInteger, BATFamilyDoctorServiceType)
{
    BATFamilyDoctorServiceVideo = 1,
    BATFamilyDoctorServiceVoice = 2,
    BATFamilyDoctorServiceTextAndImage = 3,
    BATFamilyDoctorServiceGoHome = 11,
};


/**
 家庭医生订单咨询状态
 
 BATFamilyDoctorOrderConsultStateWaitAccept =等待接单,
 BATFamilyDoctorOrderConsultStateHaveOrder =已接单,
 BATFamilyDoctorOrderConsultStateFinish = 已结束,
 BATFamilyDoctorOrderConsultStateCancel = 已取消,
 BATFamilyDoctorOrderConsultStateToRefund = 申请退款,
 BATFamilyDoctorOrderConsultStateRefundFinish = 已退款,
 
 typedef NS_ENUM(NSInteger, BATFamilyDoctorOrderConsultState)
 {
 BATFamilyDoctorOrderConsultStateWaitAccept = 1,
 BATFamilyDoctorOrderConsultStateHaveOrder = 2,
 BATFamilyDoctorOrderConsultStateFinish = 3,
 BATFamilyDoctorOrderConsultStateToRefund = 4,
 BATFamilyDoctorOrderConsultStateRefundFinish = 5,
 };
 */


/**
 家庭医生订单支付状态
 
 BATFamilyDoctorOrderPayWait =等待付款,
 BATFamilyDoctorOrderPayFinsh =已付款,
 BATFamilyDoctorOrderPayRefundFinish = 已退款,
 
 typedef NS_ENUM(NSInteger, BATFamilyDoctorOrderPayState)
 {
 BATFamilyDoctorOrderPayWait = 1,
 BATFamilyDoctorOrderPayFinsh = 2,
 BATFamilyDoctorOrderPayRefundFinish = 3,
 };
 */



/**
 家庭医生 订单支付状态+接受订单状态=》订单状态
 
 BATFamilyDoctorOrderCancel = 交易关闭
 BATFamilyDoctorOrderWaitAccept = 等待医生接单
 BATFamilyDoctorOrderWaitPay = 等待患者付款，
 BATFamilyDoctorOrderFinish = 订单结束（待评价）,
 BATFamilyDoctorOrderHavePay = 正在服务期,
 BATFamilyDoctorOrderPaySuccess = 支付完成（交易成功）
 */
typedef NS_ENUM(NSInteger, BATFamilyDoctorOrderState)
{
    BATFamilyDoctorOrderCancel = 0,
    BATFamilyDoctorOrderWaitAccept = 1,
    BATFamilyDoctorOrderWaitPay = 2,
    BATFamilyDoctorOrderFinish = 3,
    BATFamilyDoctorOrderHavePay = 4,
    BATFamilyDoctorOrderPaySuccess = 99,
};

typedef NS_ENUM(NSUInteger, BATJPushMsgType)
{
    BATJPushMsgTypeNoraml = 0,
    BATJPushMsgTypeDoctor = 1,
    BATJPushMsgTypePatient = 2,
};


/**
 医生工作室排序
 
 - BATDoctorSort_Default: 默认
 - BATDoctorSort_Integrated: 综合
 - BATDoctorSort_Consultations: 咨询次数
 - BATDoctorSort_Commnet: 评价次数
 */
typedef NS_ENUM(NSInteger,BATDoctorSort){
    
    BATDoctorSort_Default = -1,
    BATDoctorSort_Integrated = 1,
    BATDoctorSort_Consultations = 2,
    BATDoctorSort_Commnet = 3,
    
};


/**
 医生工作室订单类型

 - BATDoctorService_Video: 视频
 - BATDoctorService_Audio: 语音
 - BATDoctorService_TextAndImage: 图文
 - BATDoctorService_GoHome: 上门服务
 - BATDoctorService_HomeDoctor: 家庭医生
 */
typedef NS_ENUM(NSInteger,BATDoctorStudioOrderType){
    BATDoctorStudioOrderType_Video = 1,
    BATDoctorStudioOrderType_Audio = 2,
    BATDoctorStudioOrderType_TextAndImage = 3,
    BATDoctorStudioOrderType_HomeDoctor = 11,
};


/**
 医生工作室服务类型

 - BATDoctorStudioOrderServiceType_Video: 视频
 - BATDoctorStudioOrderServiceType_Audio: 语音
 - BATDoctorStudioOrderServiceType_TextAndImage: 图文
 - BATDoctorStudioOrderServiceType_GoHome: 上门服务
 */
typedef NS_ENUM(NSInteger,BATDoctorStudioOrderServiceType){
    BATDoctorStudioOrderServiceType_Video = 1,
    BATDoctorStudioOrderServiceType_Audio = 2,
    BATDoctorStudioOrderServiceType_TextAndImage = 3,
    BATDoctorStudioOrderServiceType_GoHome = 4,
};

/**
 名医工作室订单状态
 
 //5-未支付，6-已支付，7-未完成，3-已完成，4-已取消

 - BATDoctorStudioOrderStatus_Completion: 已完成
 - BATDoctorStudioOrderStatus_Cancel: 已取消
 - BATDoctorStudioOrderStatus_NoPay: 未支付
 - BATDoctorStudioOrderStatus_Paid: 已支付
 - BATDoctorStudioOrderStatus_NoCompletion: 未完成
 */
typedef NS_ENUM(NSInteger,BATDoctorStudioOrderStatus){
    BATDoctorStudioOrderStatus_Completion = 3,
    BATDoctorStudioOrderStatus_Cancel = 4,
    BATDoctorStudioOrderStatus_NoPay = 5,
    BATDoctorStudioOrderStatus_Paid = 6,
    BATDoctorStudioOrderStatus_NoCompletion = 7,
};

/**
 名医工作室图文咨询状态
 3-待支付，4-未回复，5-咨询取消，6-咨询结束，1-咨询中，2-咨询完成

 - BATDoctorStudioConsultStatus_Consulting: 咨询中
 - BATDoctorStudioConsultStatus_ConsultCompletion: 咨询完成
 - BATDoctorStudioConsultStatus_WaitingPay: 待支付
 - BATDoctorStudioConsultStatus_NoAnswer: 未回复
 - BATDoctorStudioConsultStatus_Cancel: 咨询取消
 - BATDoctorStudioConsultStatus_ConsultEnd: 咨询结束
 */
typedef NS_ENUM(NSInteger,BATDoctorStudioConsultStatus){
    BATDoctorStudioConsultStatus_Consulting = 1,
    BATDoctorStudioConsultStatus_ConsultCompletion = 2,
    BATDoctorStudioConsultStatus_WaitingPay = 3,
    BATDoctorStudioConsultStatus_NoAnswer = 4,
    BATDoctorStudioConsultStatus_Cancel = 5,
    BATDoctorStudioConsultStatus_ConsultEnd = 6,
};


/**
 名医工作室支付状态
 
 0-未付款，1-已付款，11-已退款
 
 - BATDoctorStudioPayStatus_NoPay: 未支付
 - BATDoctorStudioPayStatus_Payed: 已经支付
 - BATDoctorStudioPayStatus_Refund: 已经退款
 */
typedef NS_ENUM(NSInteger,BATDoctorStudioPayStatus){
    BATDoctorStudioPayStatus_NoPay = 0,
    BATDoctorStudioPayStatus_Payed = 1,
    BATDoctorStudioPayStatus_Refund = 11,
};


/**
 名医工作室评价状态

 - BATDoctorStudioCommentStatus_NoComment: 未评价
 - BATDoctorStudioCommentStatus_Commented: 已评价
 */
typedef NS_ENUM(NSInteger,BATDoctorStudioCommentStatus){
    BATDoctorStudioCommentStatus_NoComment = 0,
    BATDoctorStudioCommentStatus_Commented = 1,
};

/**
 医生工作室职称等级
 
 - BATDoctorTitleLevel_Junior: 初级
 - BATDoctorTitleLevel_Intermediate: 中级
 - BATDoctorTitleLevel_Advanced_3: 高级3
 - BATDoctorTitleLevel_Advanced_4: 高级4
 */
typedef NS_ENUM(NSInteger,BATDoctorTitleLevel){
    BATDoctorTitleLevel_Junior = 1,
    BATDoctorTitleLevel_Intermediate = 2,
    BATDoctorTitleLevel_Advanced_3 = 3,
    BATDoctorTitleLevel_Advanced_4 = 4,
};


/**
 聊天服务状态
 
 - batDoctorStudioTextImageStatus_DoctorAskOver: 医生请求结束
 - batDoctorStudioTextImageStatus_PatientAgreeOver: 患者同意结束
 - batDoctorStudioTextImageStatus_PatientCancelOver: 患者取消结束
 - batDoctorStudioTextImageStatus_PatientComplain: 患者投诉医生
 */
typedef NS_ENUM(NSInteger,BATDoctorStudioTextImageStatus){
    batDoctorStudioTextImageStatus_DoctorAskOver = 1,
    batDoctorStudioTextImageStatus_PatientAgreeOver = 2,
    batDoctorStudioTextImageStatus_PatientCancelOver = 3,
    batDoctorStudioTextImageStatus_PatientComplain = 4,
};

/**
 通话状态
 
 - BATCallState_Call: 呼叫
 - BATCallState_Answer: 接听
 - BATCallState_Calling: 通话中
 */
typedef NS_ENUM(NSInteger,BATCallState) {
    BATCallState_Call = 1,
    BATCallState_Answer = 2,
    BATCallState_Calling = 3,
};

/**
 医生工作室支付方式
 
 - BATDoctorStudioPayType_WXPay: 微信支付
 - BATDoctorStudioPayType_ALiPay: 支付宝支付
 - BATDoctorStudioPayType_KMPay: 康美支付
 */
typedef NS_ENUM(NSInteger,BATDoctorStudioPayType){
    BATDoctorStudioPayType_WXPay = 1,
    BATDoctorStudioPayType_ALiPay = 2,
    BATDoctorStudioPayType_KMPay = 3,
};

/**
 医院等级
 - BATHospitalLevelType_TeDengYY = 1,特等医院
 - BATHospitalLevelType_SanJiaYY = 2,三级甲等
 - BATHospitalLevelType_SanYiYY = 3,三级乙等
 - BATHospitalLevelType_SanBinYY = 4,三级丙等
 - BATHospitalLevelType_ErJiaYY = 5,二级甲等
 - BATHospitalLevelType_ErYiYY = 6,二级乙等
 - BATHospitalLevelType_ErBinYY = 7,二级丙等
 - BATHospitalLevelType_YiJiaYY = 8,一级甲等
 - BATHospitalLevelType_YiYiYY = 9,一级乙等
 - BATHospitalLevelType_YiBinYY = 10,一级丙等
 - BATHospitalLevelType_QiTaYY = 11,其他
 */
typedef NS_ENUM(NSInteger,BATHospitalLevelType){
    BATHospitalLevelType_TeDengYY = 1,
    BATHospitalLevelType_SanJiaYY = 2,
    BATHospitalLevelType_SanYiYY = 3,
    BATHospitalLevelType_SanBinYY = 4,
    BATHospitalLevelType_ErJiaYY = 5,
    BATHospitalLevelType_ErYiYY = 6,
    BATHospitalLevelType_ErBinYY = 7,
    BATHospitalLevelType_YiJiaYY = 8,
    BATHospitalLevelType_YiYiYY = 9,
    BATHospitalLevelType_YiBinYY = 10,
    BATHospitalLevelType_QiTaYY = 11,
};

/**
 导航首页动画方向

 - BATNavHomeAnimateDirection_Up: 向上
 - BATNavHomeAnimateDirection_Down: 向下
 */
typedef NS_ENUM(NSInteger,BATNavHomeAnimateDirection){
    BATNavHomeAnimateDirection_Up = 1,
    BATNavHomeAnimateDirection_Down = 2,
};


#endif /* BATEnumMacro_h */
