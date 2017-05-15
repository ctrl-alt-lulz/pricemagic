import React from 'react';

export default class CategoryDropDown extends React.Component {
    constructor(props) {
        super(props);
        this.state = {category: this.props.category};
    }


    render () {
        return (
            <div>
                <h1> {this.state.category[1]} what is 14?</h1>
                    <select value={this.state.category[0]}>
                        <option value="Milk">{this.state.category[1]}</option>
                        <option value="Cheese">Old Cheese</option>
                        <option value="Bread">Hot Bread</option>
                    </select>
            </div>);
    }
}
