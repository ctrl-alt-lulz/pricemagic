import React from 'react';

export default class ProductCategoryRow extends React.Component {
    render() {
        return (
            <div>
            <h3>{this.props.name}</h3>
                <p> {this.props.category}</p>
            </div>
        );
    }
}