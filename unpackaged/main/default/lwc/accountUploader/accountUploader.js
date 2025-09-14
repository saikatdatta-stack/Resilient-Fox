import { LightningElement } from 'lwc';
import uploadCSV from '@salesforce/apex/AccountCSVUploader.uploadCSV';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';



export default class AccountUploader extends LightningElement {
    fileData;

  handleFileChange(event) {
    const file = event.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = () => {
        this.fileData = reader.result;
      };
      reader.readAsText(file);
    }
  }

  handleUpload() {
    if (!this.fileData) {
      this.dispatchEvent(new ShowToastEvent({
        title: 'Error',
        message: 'Please select a CSV file first.',
        variant: 'error'
      }));
      return;
    }

    uploadCSV({ csvBody: this.fileData })
      .then(result => {
        this.dispatchEvent(new ShowToastEvent({
          title: 'Success',
          message: `${result.length} Accounts inserted successfully.`,
          variant: 'success'
        }));
      })
      .catch(error => {
        this.dispatchEvent(new ShowToastEvent({
          title: 'Upload Failed',
          message: error.body.message,
          variant: 'error'
        }));
      });
  }

}