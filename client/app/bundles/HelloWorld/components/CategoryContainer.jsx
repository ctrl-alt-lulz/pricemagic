import React from 'react';

export default class HelloWorld extends React.Component {
    render () {
        return (<div><h1> {this.props.category} </h1></div>);
    }
}

