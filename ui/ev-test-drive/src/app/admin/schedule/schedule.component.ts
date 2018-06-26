import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { EVService } from '../../common/ev.service';
import { Helpers } from '../../app.helpers';
import * as moment from 'moment';

@Component({
  selector: 'app-schedule',
  templateUrl: './schedule.component.html',
  styleUrls: ['./schedule.component.scss']
})
export class ScheduleComponent implements OnInit {

  schedule: any[] = [];
  formattedDate: string;
  helpers = new Helpers();
  isSubmitting = false;

  constructor(
    private router: Router,
    private evService: EVService) { }

  ngOnInit() {
    this.evService.getSchedule().subscribe(
      response => this.handleSchedule(response),
      error => this.handleError(error)
    );
  }

  handleSchedule(response) {
    this.formattedDate = this.formatDate(moment(response.date).toDate());
    this.schedule = response.schedules.sort((a, b) => {
      let aNum = Number(a.scheduled_start_time.substring(0,2)
                        + a.scheduled_start_time.substring(3,5));
      let bNum = Number(b.scheduled_start_time.substring(0,2)
                        + b.scheduled_start_time.substring(3,5));
      if (aNum > bNum) {
        return 1;
      } else if (aNum < bNum) {
        return -1;
      } else {
        return 0;
      }
    });
    this.schedule.forEach(slot => {
      slot.formattedTime = this.helpers.formatAMPM(slot.scheduled_start_time);
    });
  }

  handleLookupResponse(response) {
    if (response && response.email) {
      localStorage.setItem('email', response.email);
      this.evService.getPostSurvey().subscribe(
        surveyResponse => this.handleSurveyResponse(surveyResponse),
        error => this.handleError(error)
      );
    } else {
      this.handleError(null);
    }
  }

  handleSurveyResponse(response) {
    localStorage.setItem('postSurveyQuestions', JSON.stringify(response));
    this.isSubmitting = false;
    this.router.navigateByUrl('/checkout/survey');
  }

  handleError(error) {
    this.isSubmitting = false;
    console.log(error);
  }

  doCancel(confirmationNumber) {
    const driverInfoPane = document.getElementById(confirmationNumber);
    const emailPane = driverInfoPane.getElementsByClassName('email-pane').item(0);
    const cancelButton = driverInfoPane.getElementsByClassName('cancel-button').item(0);
    const cancelText = driverInfoPane.getElementsByClassName('cancel-text').item(0);
    const pinPane = driverInfoPane.getElementsByClassName('pin-pane').item(0);
    const pinField = <HTMLInputElement>(pinPane.getElementsByClassName('pin').item(0));

    if (pinPane.classList.contains('hidden')) {
      emailPane.classList.add('hidden');
      cancelText.classList.remove('hidden');
      pinPane.classList.remove('hidden');
      cancelButton.classList.add('visible');
    } else if (pinField.value) {
      console.log('Submitting cancellation!');
      console.log(pinField.value);
    } else {
      emailPane.classList.remove('hidden');
      cancelText.classList.add('hidden');
      pinPane.classList.add('hidden');
      cancelButton.classList.remove('visible');
    }
  }

  doCheckout(confirmationNumber) {
    const lookupData = { confirmationNumber: confirmationNumber };
    localStorage.setItem('confirmationNumber', confirmationNumber);
    this.isSubmitting = true;

    this.evService.lookupUser(lookupData).subscribe(
      response => this.handleLookupResponse(response),
      error => this.handleError(error)
    );
  }

  toggleMorePane(confirmationNumber) {
    const driverInfoPane = document.getElementById(confirmationNumber);
    const morePane = driverInfoPane.getElementsByClassName('more-pane').item(0);

    if (morePane) {
      morePane.classList.toggle('open');
    }
  }

  formatDate(date: Date) {
    const today = new Date();
    const months = ['January', 'February', 'March', 'April',
                    'May', 'June', 'July', 'August', 'September',
                    'October', 'November', 'December'];
    let dateStr = '';
    
    if (today.getMonth() === date.getMonth()
     && today.getDate() === date.getDate()
     && today.getFullYear() === date.getFullYear()) {
      dateStr += 'Today, ';
    }

    dateStr += `${months[date.getMonth()]} ${date.getDate()}, ${date.getFullYear()}`;

    return dateStr;
  }
}
