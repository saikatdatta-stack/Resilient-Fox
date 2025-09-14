import { LightningElement, track, wire } from 'lwc';
import getAccounts from '@salesforce/apex/AccountPaginationController.getAccounts';
import getAccountCount from '@salesforce/apex/AccountPaginationController.getAccountCount';

const PAGE_SIZE = 5;

export default class AccountPagination extends LightningElement {
    @track accounts = [];
    @track pageNumber = 1;
    @track totalRecords;
    @track totalPages;

    connectedCallback() {
        this.loadAccountCount();
        this.loadAccounts();
    }

    loadAccountCount() {
        getAccountCount()
            .then(count => {
                this.totalRecords = count;
                this.totalPages = Math.ceil(count / PAGE_SIZE);
            });
    }

    loadAccounts() {
        getAccounts({ pageNumber: this.pageNumber, pageSize: PAGE_SIZE })
            .then(data => {
                this.accounts = data;
            });
    }

    handlePrevious() {
        if (this.pageNumber > 1) {
            this.pageNumber--;
            this.loadAccounts();
        }
    }

    handleNext() {
        if (this.pageNumber < this.totalPages) {
            this.pageNumber++;
            this.loadAccounts();
        }
    }
}