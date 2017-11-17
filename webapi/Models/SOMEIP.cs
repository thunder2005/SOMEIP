using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using Swashbuckle.AspNetCore.Swagger;


namespace webapi.Models
{

    public enum eRType
    {
        /// <summary>
        /// FM
        /// </summary>
        [Description("FM")]
        FM = 0x01,

        /// <summary>
        /// AM
        /// </summary>
        [Description("AM")]
        AM = 0x02,
    }

    /// <summary>
    /// Radio channel information
    /// </summary>
    public class RadioChannelInfo
    {
        // /// <summary>
        // /// Type tt
        // /// </summary>
        // public eRType eR { get; set; }

        /// <summary>
        /// Actual frequency value
        /// </summary>

        [Required]
        [DefaultValue(101.1)]
        public float radioFreqency { get; set; }

        /// <summary>
        /// Radio Type, 0x00:Invalid, 0x01: FM, 0x02:AM
        /// </summary>
        [Required]
        [DefaultValue(0x01)]
        public int radioType { get; set; }


        /// <summary>
        /// Radio name, The maximum length of the radio name is 100 characters
        ///<para>, If the value is not successfully obtained, it is not necessary to fill in the parameter</para>
        /// </summary>
        [DefaultValue("default name")]
        public string radioName { get; set; }
    }



    /// <summary>
    /// Radio channel information
    /// </summary>
    public class SetRadioChannelInfo
    {
        /// <summary>
        /// Channel information
        /// </summary>
        [Required]
        public RadioChannelInfo ChannelInfo { get; set; }

        /// <summary>
        /// Actual frequency value
        /// </summary>

        // [Required]
        // [DefaultValue(101.1)]
        // public float radioFreqency { get; set; }

        // /// <summary>
        // /// Radio Type, 0x00:Invalid, 0x01: FM, 0x02:AM
        // /// </summary>
        // [Required]
        // [DefaultValue(0x01)]
        // public int radioType { get; set; }


    }

    /// <summary>
    /// Navigation Status information
    /// </summary>
    public class NavigationStatusInfo
    {
        /// <summary>
        /// Navigation Status, 0x00:Invalid, 0x01:Stopped, 0x02:Running
        /// </summary>

        [Required]
        [DefaultValue(0x01)]
        public int status { get; set; }

    }

    /// <summary>
    /// Navigation Map Data
    /// </summary>
    public class NavigationMapData
    {
        /// <summary>
        /// Navigation Map Data, 
        /// </summary>

        [Required]

        public byte[] mapData { get; set; }

    }

    /// <summary>
    /// NavigationData
    /// </summary>




    public class NavigationData
    {

        /// <summary>
        /// Units used for distance, 0x00:Invalid, 0x01:Kilometre, 0x02:Metre, 0x03:Foot, 0x04:Mile
        /// </summary>

        [Required]
        [DefaultValue(0x01)]
        public int unit { get; set; }

        /// <summary>
        /// Map current zoom level, range from 0x00 to 0x15, 0xff is Invalid
        /// </summary>

        [Required]
        [DefaultValue(8)]
        public int zoomLevel { get; set; }


        /// <summary>
        /// Distance data
        /// </summary>

        [Required]
        [DefaultValue(100)]
        public float distance { get; set; }

        /// <summary>
        /// Road name, The maximum length of the road name is 100 characters
        ///<para>　 </para> 
        /// </summary>

        [Required]
        [DefaultValue("road 1")]
        public string roadName { get; set; }

    }



    /// <summary>
    /// BluePhoneInfo_Call_State
    /// </summary>
    public class CallStateInfo
    {

        /// <summary>
        /// mobile phone Call status
        ///<para>[0x00: Standby status, </para> 
        ///<para>0x01: During call, </para>
        ///<para>0x02: Outgoing call, </para>
        ///<para>0x03: Failure of outgoing call, </para>
        ///<para>0x04: During call waiting, </para>
        ///<para>0x05: Incoming with Hold, </para>
        ///<para>0x06: On Hold]</para>
        /// </summary>
        [Required]
        [DefaultValue(0x00)]
        public int status { get; set; }


    }

    /// <summary>
    /// BluePhoneInfo_Call_Number
    /// </summary>
    public class CallNumberInfo
    {
        /// <summary>
        /// Address info, 
        /// </summary>
        [Required]
        public AddressInfo CallAddress { get; set; }


        public CallNumberInfo()
        {
            this.CallAddress = new AddressInfo();
        }

    }
    /// <summary>
    /// BluePhoneInfo_Call_Number
    /// </summary>
    public class BatteryInfo
    {

        /// <summary>
        ///<para> The remaining battery power is expressed as a percentage, </para>
        ///<para>range from 0x00(0) to 0x64(100), 0xff is Invalid</para>
        /// </summary>
        [Required]
        [DefaultValue(100)]
        public int batteryAllowance { get; set; }


    }

    /// <summary>
    /// AudioInfo
    /// </summary>
    public class AudioInfo
    {

        /// <summary>
        ///<para> title info, </para>
        ///<para>The maximum length of the title is 100 characters</para>
        /// </summary>
        public string title { get; set; }

        /// <summary>
        ///<para> artist text, </para>
        ///<para>The maximum length of the artist text is 100 characters</para>
        /// </summary>
        public string artist { get; set; }

        /// <summary>
        ///<para> album text, </para>
        ///<para>The maximum length of the album text is 100 characters</para>
        /// </summary>
        public string album { get; set; }

        /// <summary>
        ///<para> comment text, </para>
        ///<para>The maximum length of the comment text is 100 characters</para>
        /// </summary>
        public string comment { get; set; }

        /// <summary>
        ///<para> file text, </para>
        ///<para>The maximum length of the file text is 100 characters</para>
        /// </summary>
        public string file { get; set; }

        /// <summary>
        ///<para> lyrics text, </para>
        ///<para>The maximum length of the lyrics text is 500 characters</para>
        /// </summary>
        public string lyrics { get; set; }
    }

    public class NavigaionZoomMapOpt
    {
        /// <summary>
        /// Map current zoom level, range from 0x00 to 0x15, 0xff is Invalid
        /// </summary>
        [Required]
        [DefaultValue(8)]
        public int zoomLevel { get; set; }

        /// <summary>
        /// Central point X axis coordinate value
        /// </summary>
        [Required]
        [DefaultValue(105.1)]
        public float centerPoint_x { get; set; }

        /// <summary>
        /// Central point y axis coordinate value
        /// </summary>
        [Required]
        [DefaultValue(30.1)]
        public float centerPoint_y { get; set; }
    }

    public class RadioCtrl
    {
        /// <summary>
        /// Radio control mode, 0x00: Invalid, 0x01: Off, 0x02: On
        /// </summary>
        [Required]
        [DefaultValue(0x01)]
        public int ctrlMode { get; set; }
    }


    /// To get a list of favorite channels///
    public class RadioFavoritesInfo
    {
        /// <summary>
        /// Favorite information list 
        /// </summary>
        [Required]
        public List<RadioChannelInfo> FavoritesList { get; set; }

        public RadioFavoritesInfo()
        {
            this.FavoritesList = new List<RadioChannelInfo>();

            RadioChannelInfo r1 = new RadioChannelInfo();
            r1.radioType = 0x01;
            r1.radioFreqency = 101.8f;
            r1.radioName = "chl 1";

            RadioChannelInfo r2 = new RadioChannelInfo();
            r2.radioType = 0x02;
            r2.radioFreqency = 97.1f;
            r2.radioName = "chl 2";

            this.FavoritesList.Add(r1);
            this.FavoritesList.Add(r2);
        }
    }

    /// <summary>
    /// Used to add channels to a favorite list or to remove a specific channel from a favorite list
    /// </summary>
    public class RadioFavoriteOpt
    {
        /// <summary>
        ///  Operation  mode, 0x00:Invalid, 0x01:Add to Favorites list, 0x02:Delete from Favorites list, 
        /// </summary>
        [Required]
        [DefaultValue(0x01)]
        public int mode { get; set; }
        /// <summary>
        ///  Radio channel information 
        /// </summary>
        [Required]
        public RadioChannelInfo RadioChannelInfo { get; set; }


    }

    /// <summary>
    /// Address Info,  
    /// </summary>
    public class AddressInfo
    {
        /// <summary>
        /// name text,  
        ///<para>The maximum length of the name text is 32 characters, </para>
        ///<para>When there is no valid name, do not fill in</para>
        /// </summary>
        [DefaultValue("test")]
        public string name { get; set; }

        /// <summary>
        /// number text,  
        ///<para>The maximum length of the number text is 20 characters</para>
        /// </summary>
        [Required]
        [DefaultValue("13800000000")]
        public string number { get; set; }


        public AddressInfo()
        {
            this.name = "test";
            this.number = "13800000000";
        }

    }

    public class AllAddressInfo
    {
        /// <summary>
        /// Address list
        /// </summary>
        public List<AddressInfo> AddressList { get; set; }

        public AllAddressInfo()
        {
            this.AddressList = new List<AddressInfo>();
            AddressInfo i1 = new AddressInfo();
            i1.name = "name1";
            i1.number = "13800000001";
            AddressInfo i2 = new AddressInfo();
            i2.name = "name2";
            i2.number = "13800000002";

            this.AddressList.Add(i1);
            this.AddressList.Add(i2);
        }
    }

    /// <summary>
    /// Device Info
    /// </summary>
    public class DeviceInfo
    {
        /// <summary>
        /// Device Name
        ///<para>The maximum length of the Device Name is 20 characters</para>
        /// </summary>
        [Required]
        [DefaultValue("USB")]
        public string name { get; set; }

        /// <summary>
        /// Device description info, 
        ///<para>The maximum length of the description info is 64 characters</para>
        /// </summary>
        [DefaultValue("USB DEVICE")]
        public string description { get; set; }

    }
    /// <summary>
    /// Query Device Info 
    /// </summary>
    public class AllDeviceInfo
    {
        /// <summary>
        /// Device list 
        /// </summary>
        public List<DeviceInfo> DeviceList { get; set; }

        public AllDeviceInfo()
        {
            this.DeviceList = new List<DeviceInfo>();
            DeviceInfo d1 = new DeviceInfo();
            d1.name = "USB";
            d1.description = "USB DEVICE";

            DeviceInfo d2 = new DeviceInfo();
            d2.name = "SD CARD";
            d2.description = "SD CARD DEVICE";

            this.DeviceList.Add(d1);
            this.DeviceList.Add(d2);
        }

    }


    public class FileInfo
    {
        /// <summary>
        /// file name, 
        /// The maximum length of the name is 64 characters
        /// </summary>
        [Required]
        [DefaultValue("test.mp3")]
        public string name { get; set; }

        /// <summary>
        /// file type, 
        ///<para>0x00:FILE, 0x01:DIRECTORY</para>
        /// </summary>
        [Required]
        [DefaultValue(0)]
        public int fileType { get; set; }
    }


    public class AllFileInfo
    {
        /// <summary>
        /// file info list, 
        /// </summary>
        [Required]
        public List<FileInfo> fileInfoList { get; set; }

        public AllFileInfo()
        {
            this.fileInfoList = new List<FileInfo>();
        }
    }

    public class OpenFileRequestInfo
    {
        /// <summary>
        /// file info, 
        /// </summary>
        [Required]
        public FileInfo fileInfo { get; set; }
    }


    public class OpenFileResultInfo
    {
        /// <summary>
        /// Unique identifier for opening file, 
        /// </summary>
        [Required]
        [DefaultValue(0x01)]
        public uint mediaId { get; set; }
    }


    public class CloseMedia
    {
        /// <summary>
        /// File result information requested for operation, 
        /// </summary>
        [Required]
        public OpenFileResultInfo file { get; set; }
    }


    public class RequestPlayCtrlInfo
    {
        /// <summary>
        /// contrl mode , 
        /// <para>0x00:InActivated, 0x01:Pause, 0x02:Resume, 0x03:progress control, 0x04:Stop </para>
        /// </summary>
        [Required]
        [DefaultValue(0x04)]
        public int mode { get; set; }

        /// <summary>
        /// process val, Valid only at mode= 0x03:progress control, 
        /// <para>range from 0(0x0) to 100(0x64): Percentage value of Playback progress</para>
        /// </summary>
        [DefaultValue(0)]
        public int processVal { get; set; }

        /// <summary>
        /// file info, 
        /// </summary>
        [Required]
        public OpenFileResultInfo file { get; set; }
    }


    public class LangugeInfo
    {
        /// <summary>
        /// identifier for Languge, 0x0:English, 0x1:Chinese 
        /// </summary>
        [DefaultValue(0)]
        [Required]
        public int LangugeId { get; set; }
    }



    public class UIInfo
    {
        /// <summary>
        /// identifier for UI, 0x0:UI1, 0x1:UI2
        /// </summary>
        [DefaultValue(0)]
        [Required]
        public int UIId { get; set; }
    }


    public class RSECtrlInfo
    {
        /// <summary>
        /// RSE Voice Output Ctrl, 0x0:InActivated, 0x1:Normal, 0x02:Mute 
        /// </summary>
        [DefaultValue(0)]
        [Required]
        public int VoiceOutputCtrl { get; set; }
    }

}