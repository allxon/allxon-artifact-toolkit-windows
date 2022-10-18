# What is Allxon Artifact Toolkit
Allxon Artifact Toolkit is a simple yet powerful tool that packages all kinds of files into a unified format to support seamless operations during Allxon OTA deployment across a mass fleet of remote edge AI devices. Allxon Artifact Toolkit not only allows you to intuitively customize your OTA script and process, but it only requires four simple steps to complete artifact packaging. Whether you want to update docker image, firmware, BSP image, application file, software, script, image, video, etc., you can easily package it into an Allxon verified artifact that is readable by Allxon Portal, giving you a smoother user experience. 

# Allxon Artifact Toolkit Structure 
The Allxon Artifact Toolkit Structure below shows you the path to correctly input your files and directories in order to successfully package your OTA artifact.  
```
allxon-artifact-toolkit-windows
├── ota_content
│   └── ota_deploy.bat
├── README.md
├── ota_test.bat
├── ota_test.ps1
├── artifact_generate.bat
└── artifact_generate.ps1
```
- **ota_content**: the folder where you will put all the necessary files you want to deploy on your devices. 
- **ota_deploy.bat**:  the executable batch script that consists a series of commands and handles all operations related to OTA deployment, allowing you to customize your OTA deployment process to suit your needs. 
- **artifact_generate.bat**:  a batch script that is used to generate an OTA artifact. 
- **ota_test.bat**: a batch script that is used to test an OTA artifact. 




# How to Generate OTA Artifact Using Allxon Artifact Toolkit 
1. Make sure you have put everything (docker image, firmware, BSP image, application file, software, script, image, video, etc.) you are going to deploy onto your devices into the `ota_content` directory. 
2. Edit `ota_deploy.bat` to suit your needs. (e.g. calling an executable file to execute an action or run an application update). 
3. Run `ota_test.bat` and accept the prompt to start executing the packaging procedure.  (*make sure you have windows UAC evaluation and publisher trust*). An Allxon OTA artifact will now be generated. 
4. Run `artifact_generate.bat` and provide the file name to test the OTA artifact you have generated.  This action will simulate OTA deployment by running `ota_deploy.sh`, therefore, the artifact will be deployed on the host. 
5. Verify if the deployment operation is executed as expected as specified in `ota_deploy.bat` 


# What’s Next 

Once you have generated your Allxon OTA artifact, head over to [Allxon Portal](https://dms.allxon.com/) to start performing OTA updates from the cloud portal to fleets of edge devices! 

Follow the instrustions to [deploy Allxon OTA artifact](https://www.allxon.com/knowledge/deploy-ota-artifact).