using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using webapi.Models;
using webapi;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;


namespace webapi.Controllers
{
    /// <summary>
    /// Controller描述信息
    /// </summary>
    [AttributeUsage(AttributeTargets.Class, AllowMultiple = false)]
    public class ControllerGroupAttribute : Attribute
    {
        /// <summary>
        /// 当前Controller所属模块 请用中文
        /// </summary>
        public string GroupName { get; private set; }

        /// <summary>
        /// 当前controller用途    请用中文
        /// </summary>
        public string Useage { get; private set; }

        /// <summary>
        ///  Controller描述信息 构造
        /// </summary>
        /// <param name="groupName">模块名称</param>
        /// <param name="useage">当前controller用途</param>
        public ControllerGroupAttribute(string groupName, string useage)
        {
            if (string.IsNullOrEmpty(groupName) || string.IsNullOrEmpty(useage))
            {
                throw new ArgumentNullException("groupName||useage");
            }
            GroupName = groupName;
            Useage = useage;
        }
    }

    /// <summary>
    /// 用户控制器
    /// </summary>
    [Route("api/[controller]")]
    [Produces("application/json")]
    [ControllerGroupAttribute("SOMEIP", "TEST")]
    public class SOMEIPController : Controller
    {

        /// <summary>
        /// Get current radio channel info
        /// </summary>
        /// <returns></returns>
        [HttpGet("GetCurrentChn")]
        public RadioChannelInfo GetCurrentChn()
        {
            return new RadioChannelInfo();
        }

        /// <summary>
        /// SetRadioChnInfo
        /// </summary>
        /// <returns></returns>
        [HttpGet("SetRadioChnInfo")]
        public SetRadioChannelInfo SetRadioChnInfo()
        {
            return new SetRadioChannelInfo();
        }




        /// <summary>
        /// Get Navigation Status Info
        /// </summary>
        /// <returns></returns>
        [HttpGet("GetNavigationStatusInfo")]
        public NavigationStatusInfo GetNavigationStatusInfo()
        {
            return new NavigationStatusInfo();
        }

        /// <summary>
        /// GetNavigationData
        /// </summary>
        /// <returns></returns>
        [HttpGet("GetNavigationData")]
        public NavigationData GetNavigationData()
        {
            return new NavigationData();
        }
        /// <summary>
        /// GetNavigationData
        /// </summary>
        /// <returns></returns>
        [HttpGet("BluePhoneInfo_Call_State")]
        public CallStateInfo BluePhoneInfo_Call_State()
        {
            return new CallStateInfo();
        }

        /// <summary>
        /// BluePhoneInfo_Call_Number
        /// </summary>
        /// <returns></returns>
        [HttpGet("BluePhoneInfo_Call_Number")]
        public CallNumberInfo BluePhoneInfo_Call_Number()
        {
            return new CallNumberInfo();
        }

        /// <summary>
        /// BluePhoneInfo_Battery_Info
        /// </summary>
        /// <returns></returns>
        [HttpGet("BluePhoneInfo_Battery_Info")]
        public BatteryInfo BluePhoneInfo_Battery_Info()
        {
            return new BatteryInfo();
        }

        /// <summary>
        /// AudioInfo
        /// </summary>
        /// <returns></returns>
        [HttpGet("AudioInfo")]
        public AudioInfo AudioInfo()
        {
            return new AudioInfo();
        }

        /// <summary>
        /// Navigaion_ZoomMapOpt
        /// </summary>
        /// <returns></returns>
        [HttpGet("Navigaion_ZoomMapOpt")]
        public NavigaionZoomMapOpt Navigaion_ZoomMapOpt()
        {
            return new NavigaionZoomMapOpt();
        }
        /// <summary>
        /// RadioCtrl
        /// </summary>
        /// <returns></returns>
        [HttpGet("RadioCtrl")]
        public RadioCtrl RadioCtrl()
        {
            return new RadioCtrl();
        }
        /// <summary>
        /// Get RadioFavorites
        /// </summary>
        /// <returns></returns>
        [HttpGet("GetRadioFavorites")]
        public RadioFavoritesInfo RadioFavoritesInfo()
        {
            return new RadioFavoritesInfo();
        }


        /// <summary>
        /// Get GetAddresslist
        /// </summary>
        /// <returns></returns>
        [HttpGet("GetAddresslist")]
        public AllAddressInfo GetAddresslist()
        {
            return new AllAddressInfo();
        }

        /// <summary>
        ///  QueryDeviceInfo
        /// </summary>
        /// <returns></returns>
        [HttpGet("QueryDeviceInfo")]
        public AllDeviceInfo QueryDeviceInfo()
        {
            return new AllDeviceInfo();
        }

        /// <summary>
        ///  QueryFileAllInfo
        /// </summary>
        /// <returns></returns>
        [HttpGet("QueryFileAllInfo")]
        public AllFileInfo QueryFileAllInfo()
        {
            return new AllFileInfo();
        }


        /// <summary>
        ///  QueryFileInfo
        /// </summary>
        /// <returns></returns>
        [HttpGet("QueryFileInfo")]
        public FileInfo QueryFileInfo()
        {
            return new FileInfo();
        }

        /// <summary>
        ///  OpenMedia
        /// </summary>
        /// <param name="name">file name</param>
        /// <returns></returns>
        [HttpGet("OpenMedia")]
        public OpenFileRequestInfo OpenMedia(string name)
        {
            return new OpenFileRequestInfo();
        }


        /// <summary>
        ///  Response OpenResultInfo
        /// </summary>
        /// <returns></returns>
        [HttpGet("ResponseOpenResultInfo")]
        public OpenFileResultInfo ResponseOpenResultInfo()
        {
            return new OpenFileResultInfo();
        }

        /// <summary>
        ///  CloseMedia
        /// </summary>
        /// <returns></returns>
        [HttpGet("CloseMedia")]
        public CloseMedia CloseMedia()
        {
            return new CloseMedia();
        }

        /// <summary>
        ///  MutiMedia_PlayCtrl
        /// </summary>
        /// <returns></returns>
        [HttpGet("MutiMedia_PlayCtrl")]
        public RequestPlayCtrlInfo RequestPlayCtrlInfo()
        {
            return new RequestPlayCtrlInfo();
        }

        /// <summary>
        ///  LangugeInfo
        /// </summary>
        /// <returns></returns>
        [HttpGet("LangugeInfo")]
        public LangugeInfo LangugeInfo()
        {
            return new LangugeInfo();
        }
        /// <summary>
        ///  UIInfo
        /// </summary>
        /// <returns></returns>
        [HttpGet("UIInfo")]
        public UIInfo UIInfo()
        {
            return new UIInfo();
        }

        /// <summary>
        ///  RSECtrlInfo
        /// </summary>
        /// <returns></returns>
        [HttpGet("RSECtrlInfo")]
        public RSECtrlInfo RSECtrlInfo()
        {
            return new RSECtrlInfo();
        }


        /// <summary>
        ///  RadioFavoriteOpt
        /// </summary>
        /// <returns></returns>
        [HttpGet("RadioFavoriteOpt")]
        public RadioFavoriteOpt RadioFavoriteOpt()
        {
            return new RadioFavoriteOpt();
        }


    }

}