import { LightningElement,wire } from 'lwc';
import { NavigationMixin,CurrentPageReference } from 'lightning/navigation';
import postToLinkedin from '@salesforce/apex/LinkedinPostRequest.postToLinkedin';

export default class LinkedinPostRequest extends NavigationMixin(LightningElement) {
    authURL = 'https://www.linkedin.com/oauth/v2/authorization?response_type=code&client_id='FromApp'&scope=w_member_social%20r_liteprofile&state=123&redirect_uri='FromApp''

    currentPageReference = null; 
    urlStateParameters = null;
    showAccessTokenButton = false
    accessToken = null;
    showSpinner = false
    postSuccess = false
    postError = false

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
       if (currentPageReference) {
          this.urlStateParameters = currentPageReference.state;
          console.log(this.urlStateParameters)
          if (this.urlStateParameters.code) {
            this.showAccessTokenButton = true
          }
       }
    }

    httpRedirect() {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: this.authURL
            }
        },
        true // Replaces the current page in your browser history with the URL
        );
    }

    restart() {
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__webPage',
            attributes: {
                url: ''
            }
        }).then(url => {
            window.open("'FromApp'", "_self");
        });
    }

    fetchAccessToken() {
        var inputCmp = this.template.querySelector('.inputCmp');
        var value = inputCmp.value;
        console.log('value',value)
        if(value=='' || value==undefined || value==null) {
            inputCmp.reportValidity();
            return
        }

        this.showSpinner = true

        postToLinkedin({authCode: this.urlStateParameters.code,body:value,token:this.accessToken}).then(result=>{
            console.log('result',JSON.stringify(result))
            if((JSON.stringify(result)).includes("error")) {
                this.postError = true
                this.postSuccess = false
                this.showSpinner = false
                return                
            }

            //const obj = JSON.parse(result)
            if(!this.accessToken) {
                console.log('inside Accesstoken')
                this.accessToken = result["accToken"]
            }
            this.showSpinner = false
            this.postError = false
            this.postSuccess = true
            //console.log(this.accessToken)
        }).catch(error=>{
            this.postError = true
            this.postSuccess = false
            this.showSpinner = false
            console.log('error',JSON.stringify(error))
        })

        

    }

}