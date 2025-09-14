import { LightningElement, wire } from 'lwc';
import getAccounts from '@salesforce/apex/getAccounts.getAccounts';

export default class GetAccount extends LightningElement {
    accounts;
    error;
    columns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Industry', fieldName: 'Industry' },
        { label: 'Phone', fieldName: 'Phone' }
    ];

    @wire(getAccounts)
    wiredAccounts({ error, data }) {
        if (data) {
            this.accounts = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.accounts = undefined;
        }
    }
}