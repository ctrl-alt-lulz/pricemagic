import React from 'react'
import ReactDOM from 'react-dom'
import NativeListener from 'react-native-listener';

export default class RecurringChargesLink extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
    };
    this.handleButtonClick = this.handleButtonClick.bind(this);
  }
  handleButtonClick (e) {
    e.preventDefault();
    e.stopPropagation();
    this.createRecurringCharge()
  }
 
  render() {
    const linkStyle = {
      color: 'white',
    };
    return (<div>
              <NativeListener onClick={this.handleButtonClick.bind(this)}>
                <a href="/recurring_charges" style={linkStyle} data-method="post">Subscribe</a>
              </NativeListener>
            </div>
    );
  }
  createRecurringCharge() {
    $.ajax( {
      type: "POST",
      dataType: "json",
      url: '/recurring_charges',
      data: {},
      success: function(response) {
        window.top.location.href = response.redirect_url 
      }.bind(this),
      error: function(response) {
        console.log('fail')
      }.bind(this)
    });
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('reccuring_charges')
ReactDOM.render(<RecurringChargesLink />, node)
})
